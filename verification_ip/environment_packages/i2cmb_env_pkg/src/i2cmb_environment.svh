class environment extends ncsu_component;

    env_configuration configuration;
    wb_agent          wb_agent;
    i2c_agent         i2c_agent;
    predictor         pred;
    scoreboard        scbd;
    coverage_wb       cov_wb;
    coverage_i2c      cov_i2c;

    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
    endfunction 

    function void set_configuration(env_configuration cfg);
        configuration = cfg;
    endfunction

    virtual function void build();
        wb_agent = new("wb_agent",this);
        wb_agent.set_configuration(configuration.wb_agent_config);
        wb_agent.build();
        i2c_agent = new("i2c_agent",this);
        i2c_agent.set_configuration(configuration.i2c_agent_config);
        i2c_agent.build();
        pred  = new("pred", this);
        pred.set_configuration(configuration);
        pred.build();
        scbd  = new("scbd", this);
        scbd.build();
        /* cov_int = new("cov_int", this); */
        /* cov_int.set_configuration(configuration); */
        /* cov_int.build(); */
        cov_i2c = new("cov_i2c", this);
        cov_i2c.set_configuration(configuration);
        cov_i2c.build();
        cov_wb = new("cov_wb", this);
        cov_wb.set_configuration(configuration);
        cov_wb.build();
        wb_agent.connect_subscriber(cov_wb);
        wb_agent.connect_subscriber(pred);
        pred.set_scoreboard(scbd);
        i2c_agent.connect_subscriber(scbd);
        i2c_agent.connect_subscriber(cov_i2c);
    endfunction

    function ncsu_component#(wb_transaction_base) get_wb_agent();
        return wb_agent;
    endfunction

    function ncsu_component#(i2c_transaction_base) get_i2c_agent();
        return i2c_agent;
    endfunction

    virtual task run();
        wb_agent.run();
        i2c_agent.run();
    endtask

endclass
