class coverage_wb extends ncsu_component#(.T(wb_transaction_base));

    env_configuration     configuration;
    wb_transaction_base  coverage_transaction;
    bit we;
    bit [1:0] addr;
    bit [7:0] data;
    bit bb;
    bit bc;
    bit cmnd;
    bit don;

    covergroup wb_cg;
        option.per_instance = 1;
        option.name = get_full_name();
        bb: coverpoint bb;
        bc: coverpoint bc;
        cmnd: coverpoint cmnd;
        don: coverpoint don;
        coverage_wb_we: coverpoint we;
        coverage_wb_addr: coverpoint addr;

        coverage_wb_addr_x_we: cross coverage_wb_addr, coverage_wb_we;
    endgroup

    function void set_configuration(env_configuration cfg);
        configuration = cfg;
    endfunction

    function new(string name = "", ncsu_component_base parent = null); 
        super.new(name,parent);
        wb_cg = new;
    endfunction

    virtual function void nb_put(T trans);
        /* $display({get_full_name()," ",trans.convert2string()}); */
        we = trans.wb_op;
        addr = trans.reg_addr;

        if(trans.reg_addr == 2)
        begin
            bb = trans.data[5];
            bc = trans.data[4];
            cmnd = trans.data[2:0];
            don = trans.data[7];
        end

        wb_cg.sample();

        assert__bit_fsm_invalid:assert(1);

        assert__byte_fsm_invalid:assert(1);
    endfunction

endclass
