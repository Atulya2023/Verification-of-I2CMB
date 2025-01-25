class wb_coverage extends ncsu_component#(.T(wb_transaction_base));

    wb_configuration configuration;
    header_type_t     header_type;
    header_sub_type_t header_sub_type;
    trailer_type_t    trailer_type;
    bit we;
    bit [1:0] addr;


    covergroup wb_transaction_cg;
        option.per_instance = 1;
        option.name = get_full_name();

        wb_we_cg: coverpoint we;
        wb_addr_cg: coverpoint addr;
        wb_addr_x_we: cross wb_we_cg, wb_addr_x_we;
    endgroup

    function new(string name = "", ncsu_component #(T) parent = null); 
        super.new(name,parent);
        wb_transaction_cg = new;
    endfunction

    function void set_configuration(wb_configuration cfg);
        configuration = cfg;
    endfunction

    virtual function void nb_put(T trans);
        $display("wb_coverage::nb_put() %s called",get_full_name());
        we = trans.op_type;
        addr = trans.reg_addr;
        wb_transaction_cg.sample();
    endfunction

endclass
