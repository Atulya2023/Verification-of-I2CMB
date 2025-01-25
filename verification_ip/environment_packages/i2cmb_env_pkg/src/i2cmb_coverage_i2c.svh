class coverage_i2c extends ncsu_component#(.T(i2c_transaction_base));

    env_configuration     configuration;
    i2c_transaction_base  coverage_transaction;
    bit op_type;
    bit [1:0] addr;
    bit [7:0] data[$];


    covergroup i2c_cg;
        option.per_instance = 1;
        option.name = get_full_name();
        coverage_i2c_op_type: coverpoint op_type;
        coverage_i2c_addr: coverpoint addr;
    endgroup

    function void set_configuration(env_configuration cfg);
        configuration = cfg;
    endfunction

    function new(string name = "", ncsu_component_base parent = null); 
        super.new(name,parent);
        i2c_cg = new;
    endfunction

    virtual function void nb_put(T trans);
        /* $display({get_full_name()," ",trans.convert2string()}); */
        op_type = trans.op_type;
        addr = trans.addr;
        i2c_cg.sample();
    endfunction

endclass
