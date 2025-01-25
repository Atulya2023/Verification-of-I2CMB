class predictor extends ncsu_component#(.T(wb_transaction_base));

    ncsu_component#(i2c_transaction_base) scoreboard;
    i2c_transaction_base transport_trans, transport_trans_out;
    env_configuration configuration;

    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
        transport_trans = new("transport_trans");
        transport_trans_out = new("transport_trans_out");
    endfunction

    function void set_configuration(env_configuration cfg);
        configuration = cfg;
    endfunction

    virtual function void set_scoreboard(ncsu_component #(i2c_transaction_base) scoreboard);
        this.scoreboard = scoreboard;
    endfunction

    bit [7:0] data[$];
    bit       we[];
    bit [7:0] fsmr;
    bit [7:0] cmdr;
    bit [7:0] dpr;
    bit [7:0] csr;

    bit [1:0] reg_addr[];
    bit enable;
    bit started;
    bit stop;

    virtual function void nb_put(T trans);
        /* $display({get_full_name()," ",trans.convert2string()}); */


        //Master_write()
        if (trans.wb_op == 1)
        begin
            case(trans.reg_addr)
                2'b00:begin
                    if ( trans.data[7] == 1 )
                    begin
                        enable = 1;
                    end

                    else
                    begin
                        enable = 0;
                    end

                    //Reset all other registers to default values
                    /* dpr = 8'bxxxxxxxx; */
                    /* cmdr = 8'bxxxxxxxx; */
                end

                2'b01:begin
                    /* dpr = trans.data; */
                    data.push_back(trans.data);
                    /* $display("pred trans.wb_op = 0x%x, data = %p",trans.wb_op, data); */

                    {transport_trans.addr, transport_trans.op_type} = data[0];
                    transport_trans.data = data[2:data.size()-1];
                    /* $display({"transport_trans     ",transport_trans.convert2string()}); */
                    scoreboard.nb_transport(transport_trans, transport_trans_out);
                end
                2'b10:begin

                    /* if ( cmdr[2:0] == 3'b001 ) */
                    /* begin */
                    /*     data.push_back(dpr); */
                    /* end */
                    /* $display("Inside CMDR data with trans.data = 0x%x", trans.data); */
                    if(trans.data[2:0] == 3'b100 || trans.data[2:0] == 3'b101)
                    begin
                        if(data.size() != 0)
                        begin
                            {transport_trans.addr, transport_trans.op_type} = data.pop_front();
                            transport_trans.data = data;

                            data.delete();

                        end
                    end

                    /* if(trans.data == 8'bxxxxx) */

                end
            endcase
        end

        //master_read()
        else
        begin
            if(trans.reg_addr == 2'b01)
            begin
                /* data.push_back(dpr); */
                data.push_back(trans.data);
                /* $display("pred trans.wb_op = 0x%x, data = %p",trans.wb_op, data); */

                {transport_trans.addr, transport_trans.op_type} = data[0];
                transport_trans.data = data[2:data.size()-1];
                /* $display({"transport_trans     ",transport_trans.convert2string()}); */
                scoreboard.nb_transport(transport_trans, transport_trans_out);
            end 
        end


    endfunction

endclass
