class wb_driver extends ncsu_component#(.T(wb_transaction_base));

    localparam [1:0]
        CSR = 2'b00,
        DPR = 2'b01,
        CMDR = 2'b10,
        FSM = 2'b11;

    localparam [7:0] 
        ENABLE = 8'b11xxxxxx;
        SET_BUS = 8'bxxxxx110,
        START = 8'bxxxxx100,
        WRITE = 8'bxxxxx001,
        STOP = 8'bxxxxx101;
        
    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
    endfunction

    virtual wb_if bus;
    wb_configuration configuration;
    wb_transaction_base wb_trans;

    function void set_configuration(wb_configuration cfg);
        configuration = cfg;
    endfunction

    virtual task bl_put(T trans);
        bit [7:0] temp_read;
        bit [7:0] temp_write_data;
        bit [7:0] temp_data[] = trans.data;
        $display({get_full_name()," ",trans.convert2string()});

        //Enable
        bus.master_write(CSR, ENABLE);
        bus.master_write(DPR, 8'h01);
        bus.master_write(CMDR, SET_BUS);
        bus.wait_for_interrupt();
        bus.master_read(CMDR, temp_read);

        //Start
        bus.master_write(CMDR, START);
        bus.wait_for_interrupt();
        bus.master_read(CMDR, temp_read);

        // Send Address and op_type
        temp_write_data[7:1] = trans.addr;
        temp_write_data[0] = trans.op_type;
        bus.master_write(DPR, temp_write_data);
        bus.master_write(CMDR, WRITE);
        bus.wait_for_interrupt();
        bus.master_read(CMDR, temp_read);

        // Write data to bus 
        if(trans.op_type == WRITE)
        begin
            foreach(temp_data[i])
            begin
                //Write each byte of data to the bus
                wb_bus.master_write(DPR, temp_data[i]);
                wb_bus.master_write(CMDR, WRITE);
                wb_bus.wait_for_interrupt();
                wb_bus.master_read(CMDR, temp_read);
            end
        end

        // Read data from bus
        else
        begin
            
        end

        

    endtask

endclass
