class wb_driver extends ncsu_component#(.T(wb_transaction_base));

    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
    endfunction

    virtual wb_if bus;
    wb_configuration configuration;
    /* wb_transaction_base wb_trans; */

    function void set_configuration(wb_configuration cfg);
        configuration = cfg;
    endfunction

    virtual task bl_put(T trans);
        bit [7:0] temp_data;
        bit [1:0] temp_reg;
        /* $display({get_full_name()," ",trans.convert2string()}); */
        /* $display("wb_driver at %t", $time); */

        temp_reg = trans.reg_addr;
        if ( trans.wb_op == 1 )
        begin
            bus.master_write(trans.reg_addr, trans.data);
            if(trans.reg_addr == 2)
            begin
                /* $display({get_full_name()," Waiting for interrupt ",trans.convert2string()}); */
                bus.wait_for_interrupt();
            end
        end

        else //( trans.wb_op == 0 )
        begin
            /* $display({get_full_name()," READ ",trans.convert2string()}); */
            bus.master_read(trans.reg_addr, trans.data);
        end
    endtask

    virtual task bl_put_ref(ref T trans);
        bit [7:0] temp_data;
        bit [1:0] temp_reg;
        /* $display({get_full_name()," ",trans.convert2string()}); */
        /* $display("wb_driver at %t", $time); */

        temp_reg = trans.reg_addr;
        if ( trans.wb_op == 1 )
        begin
            bus.master_write(trans.reg_addr, trans.data);
            if(trans.reg_addr == 2)
            begin
                /* $display({get_full_name()," Waiting for interrupt ",trans.convert2string()}); */
                bus.wait_for_interrupt();
            end
        end

        else //( trans.wb_op == 0 )
        begin
            /* $display({get_full_name()," READ ",trans.convert2string()}); */
            bus.master_read(trans.reg_addr, trans.data);
        end
    endtask


endclass
