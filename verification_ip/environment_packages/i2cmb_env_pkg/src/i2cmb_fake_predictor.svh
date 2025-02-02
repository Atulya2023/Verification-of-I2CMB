class predictor extends ncsu_component#(.T(wb_transaction_base));

    ncsu_component#(T) scoreboard;
    /* i2c_transaction_base i2c_transport_trans; */
    wb_transaction_base wb_transport_trans;
    env_configuration configuration;






    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
    endfunction

    function void set_configuration(env_configuration cfg);
        configuration = cfg;
    endfunction

    virtual function void set_scoreboard(ncsu_component #(T) scoreboard);
        this.scoreboard = scoreboard;
    endfunction

    virtual function void nb_put(T trans);
        $display({get_full_name()," ",trans.convert2string()});
        scoreboard.nb_transport(trans, transport_trans);
    endfunction

endclass
