class coverage extends ncsu_component#(.T(wb_transaction_base));

    env_configuration     configuration;
    wb_transaction_base  coverage_transaction;
    bit we;
    bit [1:0] addr;
    bit [7:0] data;


    covergroup coverage_cg;
        option.per_instance = 1;
        option.name = get_full_name();
        coverage_we: coverpoint we;
        coverage_addr: coverpoint addr;
    endgroup

    function void set_configuration(env_configuration cfg);
        configuration = cfg;
    endfunction

    function new(string name = "", ncsu_component #(T) parent = null); 
        super.new(name,parent);
        coverage_cg = new;
    endfunction

    virtual function void nb_put(T trans);
        $display({get_full_name()," ",trans.convert2string()});
        we = trans.wb_op;
        addr = trans.reg_addr;
        coverage_cg.sample();
    endfunction

endclass
