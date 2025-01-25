class test_base extends ncsu_component#(.T(ncsu_transaction));

    env_configuration  cfg;
    environment        env;
    generator          gen;
    string gen_type;


    function new(string name = "", ncsu_component_base parent = null); 
        super.new(name,parent);

        if(!$value$plusargs("GEN_TYPE=%s", gen_type)) $fatal("FATAL: +GEN_TYPE plusarg not found on command line");
        else ncsu_info("i2cmb_test::new()", $sformatf("found +GEN_TYPE=%s", gen_type),NCSU_NONE);

        cfg = new(gen_type);
        env = new("env",this);
        env.set_configuration(cfg);
        env.build();
        gen = new("gen",this);
        $cast(gen, ncsu_object_factory::create(gen_type));
        gen.set_wb_agent(env.get_wb_agent());
        gen.set_i2c_agent(env.get_i2c_agent());
    endfunction

    virtual task run();
        env.run();
        gen.run();
    endtask

endclass
