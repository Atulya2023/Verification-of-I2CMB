`timescale 1ns / 10ps

interface i2c_if       #(
    int ADDR_WIDTH = 7,
    int DATA_WIDTH = 8                                
)
    (
        // System sigals
        input scl,
        triand sda
    );

    logic sda_bit, sda_drive;

    assign sda = sda_drive? sda_bit:1'bz;

    /* typedef enum bit {WRITE_OP, READ_OP} i2c_op_t; */

    task i2c_start();
        automatic int started = 0;
        while(!started)
        begin
            @(negedge sda);
            started = scl;
        end
    endtask

    task i2c_stop();
        automatic int stopped = 0;
        while(!stopped)
        begin
            @(posedge sda);
            stopped = scl;
        end
    endtask

    task send_acknowledge();
        @(negedge scl);
        sda_bit = 1'b0;
        sda_drive = 1'b1;

        @(negedge scl);
        sda_drive = 1'b0;
    endtask

    task snoop_data(
        output bit [DATA_WIDTH-1:0] data
    );
        automatic int i;

        for(i=0;i<8;i++)
        begin
            @(posedge scl);
            data[7-i] = sda;
        end

        @(negedge scl);

    endtask

    task get_address_op(
        output bit [ADDR_WIDTH-1:0] addr,
        output bit op
    );
        automatic int i;

        //Get 7 address bits
        for(i=0;i<7;i++)
        begin
            @(posedge scl);
            addr[6-i] = sda;
        end

        //Get operation (read/write)
        @(posedge scl);
        op = 0; //WRITE_OP;
        if(sda == 1)
            op = 1;//READ_OP;

    endtask

    task wait_for_i2c_transfer(
        output bit op, 
        output bit [DATA_WIDTH-1:0] write_data []
    );
        bit [ADDR_WIDTH-1:0] addr; 
        bit [DATA_WIDTH-1:0] data;                         
        automatic int block;
        i2c_start();
        get_address_op(addr, op);
        send_acknowledge();


        if(op == 0)
        begin
            while(block != 2)
                fork
                    fork
                        begin
                            snoop_data(data);
                            //Acknowledge       
                            @(negedge scl);

                            write_data = new[write_data.size()+1] (write_data);
                            write_data[write_data.size()-1] = data;
                            block = 1;
                        end

                        begin
                            i2c_stop();
                            block = 2;
                        end

                        begin
                            i2c_start();
                            block = 3;
                        end
                    join_any
                    disable fork;
                join
        end

    endtask


    task provide_read_data(
        input bit [DATA_WIDTH-1:0] read_data[],
        output bit transfer_complete
    );

        automatic int i, j, size;
        transfer_complete = 0;
        size = read_data.size();

        for(i=0;i<size;i++)
        begin
            for(j=DATA_WIDTH-1;j>=0;j--)
            begin
                sda_bit = read_data[i][j];
                sda_drive = 1;
                @(negedge scl);
            end
            sda_drive = 0;
            //Acknowledge 
            @(negedge scl);

        end

        transfer_complete = 1;


    endtask


    task monitor(
        output bit [ADDR_WIDTH-1:0] addr,
        output bit op,
        output bit [DATA_WIDTH-1:0] data[]
    );

        automatic int block = 0;
        automatic bit [DATA_WIDTH-1:0] temp_data [];

        bit [DATA_WIDTH-1:0] snooped_data;

        sda_drive = 0;

        //Wait for START signal          
        i2c_start();

        get_address_op(addr, op);

        //Ignore acknowledge
        @(posedge scl);
        @(negedge scl);


        while(block != 2)
        begin
            fork
                fork
                    begin
                        snoop_data(snooped_data);
                        //Ignore Acknowledge
                        @(negedge scl);

                        temp_data = new[temp_data.size()+1] (temp_data);
                        temp_data[temp_data.size()-1] = snooped_data;
                        block = 1;
                    end

                    begin
                        i2c_stop();
                        block = 2;
                    end

                    begin
                        i2c_start();
                        block = 3;
                    end
                join_any
                disable fork;
            join
        end

        data = temp_data;

    endtask

endinterface
