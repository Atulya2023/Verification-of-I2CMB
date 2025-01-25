class generator_reg_test extends generator;
    `ncsu_register_object(generator_reg_test)

    i2c_transaction_base i2c_transactions[$];
    wb_transaction_base wb_transactions[$];
    ncsu_component #(i2c_transaction_base) i2c_agent;
    ncsu_component #(wb_transaction_base) wb_agent;

    wb_transaction_base wb_trans;
    i2c_transaction_base i2c_trans;

    bit [7:0] default_values[3];
    bit [7:0] access_values[3];
    int i;


    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
        wb_trans = new("wb_trans");
        i2c_trans = new("i2c_trans");

        default_values[0] = 8'h00;
        default_values[1] = 8'h00;
        default_values[2] = 8'h80;
        default_values[3] = 8'h00;

        access_values[0] = 8'b11000000;
        access_values[1] = 8'b00000000;
        access_values[2] = 8'b00010111;
        access_values[3] = 8'b00000000;
    endfunction

    virtual task run();
        begin: reg_reset
            $display("##############REGISTER DEFAULTS AND ACCESS TEST###############");

            for(int i=0;i<4;i++)
            begin
                wb_trans.data = 8'hff;
                wb_trans.reg_addr = i;
                wb_trans.wb_op = 0;

                super.wb_agent.bl_put_ref(wb_trans);
                /* wb_read_reg(2'b00); */
                assert(wb_trans.data == default_values[i]) //$display(" Reset Signal works. Checked default values");
                else $fatal("Faulty Reset Value for Register with address 0x%x: %b", i, wb_trans.data);
            end
            /* $display("wb_trans.data = %b, wb_trans.reg_addr = %d, wb_trans.wb_op = %b", wb_trans.data, wb_trans.reg_addr, wb_trans.wb_op); */
            $display("Checked RESET Values of all registers.");
        end

        /* wb_enable(); */

        begin: reg_access
            $display("#########REGISTER PERMISSIONS#############");

            for(i=0;i<4;i++)
            begin
                wb_trans.data = 8'hff;
                wb_trans.reg_addr = i;
                wb_trans.wb_op = 1;
                super.wb_agent.bl_put_ref(wb_trans);

                wb_trans.wb_op = 0;
                super.wb_agent.bl_put_ref(wb_trans);

                assert(wb_trans.data == access_values[i]) //$display(" REG %d reads value %b", i, wb_trans.data);
                else $fatal("Faulty access Value for Register with address 0x%x: %b",i, wb_trans.data);
            end
            $display("Checked Access Permissions of all registers.");

        end
    endtask

    /* virtual task wb_read_reg(bit [1:0] reg_addr); */
    /*     send_wb_transaction() */
    /* endtask */

endclass
