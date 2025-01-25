class generator extends ncsu_component#();
    `ncsu_register_object(generator)

    i2c_transaction_base i2c_transactions[$];
    wb_transaction_base wb_transactions[$];
    ncsu_component #(i2c_transaction_base) i2c_agent;
    ncsu_component #(wb_transaction_base) wb_agent;

    wb_transaction_base wb_trans;
    i2c_transaction_base i2c_trans;
    bit [7:0] bus_id;
    bit [6:0] address;

    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
        wb_trans = new("wb_trans");
        i2c_trans = new("i2c_trans");
    endfunction

    virtual task run();
        fork
            begin: wb_test_flow
                /* $display("Test 1 WB \(Write 32 bytes\)"); */
                /* send_wb_transaction(8'b11xxxxxx, 2'b00); */
                /* send_wb_transaction(8'h05, 2'b01); */
                address = 0;
                wb_enable();
                wb_set_bus(8'h01);
                wb_reset_interrupt();
                wb_start();
                wb_set_address(address++, 0);
                address = address<<1;

                for(int i =0; i<32; i++)
                begin
                    wb_write_byte(8'(i));
                end

                /* send_wb_transaction(8'bxxxxx101, 1, 2'b10); */
                wb_stop();

                /* $display("Test 2 WB \(Read 32 bytes\)"); */
                wb_set_bus(8'h01);
                wb_reset_interrupt();
                wb_start();
                wb_set_address(address++, 1);
                address = address<<1;

                for(int i = 0; i < 32; i++)
                begin
                    wb_read_byte();
                end

                wb_stop();

                /* $display("Test 3 WB \(Alternate Writes and Reads for 64 bytes\)"); */
                for(int i = 64; i<128; i++)
                begin
                    wb_set_bus(8'h01);
                    wb_reset_interrupt();
                    wb_start();
                    wb_set_address(address++, 0);
                    address = address<<1;
                    wb_write_byte(8'(i));
                    wb_stop();
                    /* $display("Test 3 WB wrote %d", i); */

                    wb_set_bus(8'h01);
                    wb_reset_interrupt();
                    wb_start();
                    wb_set_address(address++, 1);
                    wb_read_byte();
                    wb_stop();
                    /* $display("Test 3 WB read instance %d", i); */

                end

                /* foreach(wb_transactions[i]) */
                /* begin */
                /*     wb_agent.bl_put(wb_transactions[i]); */
                    
                /* end */


            end

            begin: i2c_test_flow
                address = 0;
                i2c_trans.addr = address<<1;
                /* address = address<<1; */
                $display("Testcase 1 I2C \(Read Multiple bytes\)");
                i2c_agent.bl_put(i2c_trans);

                $display("Testcase I2C \(Write Multiple bytes\)");
                for(int j = 100; j<132; j++)
                begin
                    i2c_trans.data.push_back(8'(j));
                end

                i2c_trans.op_type = 1;
                i2c_trans.addr = address<<1;
                /* address = address<<1; */

                /* i2c_transactions.push_back(i2c_trans); */
                i2c_agent.bl_put(i2c_trans);

                i2c_trans.data.delete();
                $display("Testcase 2 I2C \(Alternate Reads and Writes for Single Byte of Data\)");
                for( int j = 0; j < 128; j++)
                begin
                    if(j & 1'b1)
                    begin
                        i2c_trans.data.push_back(8'(63-j/2));
                        i2c_trans.op_type = 1;
                    end

                    else
                    begin
                        i2c_trans.op_type = 0;
                    end

                    /* i2c_transactions.push_back(i2c_trans); */
                    i2c_trans.addr = address<<1;
                    /* address = address<<1; */
                    i2c_agent.bl_put(i2c_trans);
                    i2c_trans.data.delete();
                end
                /* $display("All Tests completed succesfully"); */

                /* foreach(i2c_transactions[i]) */
                /* begin */
                /*     i2c_agent.bl_put(i2c_transactions[i]); */
                    
                /* end */
            end
        join
    endtask

    function void set_i2c_agent(ncsu_component #(i2c_transaction_base) agent);
        this.i2c_agent = agent;
    endfunction

    function void set_wb_agent(ncsu_component #(wb_transaction_base) agent);
        this.wb_agent = agent;
    endfunction

    task send_wb_transaction(bit [7:0] data, bit op_type, bit [1:0] reg_addr);

        /* $cast(wb_trans,ncsu_object_factory::create(wb_transaction_base)); *1/ */
        wb_trans.data = data;
        wb_trans.wb_op = op_type;
        wb_trans.reg_addr = reg_addr;
        /* $display("wb_agent.bl_put data = 0x%x, wb_op = 0x%x, addr = 0x%x at %t", wb_trans.data, wb_trans.wb_op, wb_trans.reg_addr, $time); */
        wb_agent.bl_put(wb_trans);
        /* wb_transactions.push_back(wb_trans); */
    endtask


    task wb_enable();
        send_wb_transaction(8'b11xxxxxx, 1, 2'b00);
    endtask

    task wb_set_bus(bit [7:0] bus_id);
        send_wb_transaction(bus_id, 1, 2'b01);
        send_wb_transaction(8'bxxxxx110, 1, 2'b10);
    endtask

    task wb_start();
        send_wb_transaction(8'bxxxxx100, 1, 2'b10);
        wb_reset_interrupt();
    endtask

    task wb_set_address(bit [6:0] addr, bit we);
        send_wb_transaction({addr, we}, 1, 2'b01);
        send_wb_transaction(8'bxxxxx001, 1, 2'b10);
        wb_reset_interrupt();
    endtask

    task wb_reset_interrupt();
        send_wb_transaction(8'hxx, 0, 2'b10);
    endtask

    task wb_write_byte(bit [7:0] data);
        send_wb_transaction(data, 1, 2'b01);
        send_wb_transaction(8'bxxxxx001, 1, 2'b10);
        wb_reset_interrupt();
    endtask


    task wb_stop();
        send_wb_transaction(8'bxxxxx101, 1, 2'b10);
        wb_reset_interrupt();
    endtask

    task wb_read_byte();
        send_wb_transaction(8'bxxxxx011, 1, 2'b10);
        wb_reset_interrupt();
        /* send_wb_transaction(8'hxx, 0, 2'b01); */
        wb_trans.data = 8'hxx;
        wb_trans.wb_op = 0;
        wb_trans.reg_addr = 2'b01;
        wb_agent.bl_put_ref(wb_trans);
    endtask


endclass
