class i2c_driver extends ncsu_component#(.T(i2c_transaction_base));

    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
    endfunction

    virtual i2c_if bus;
    i2c_configuration configuration;
    i2c_transaction_base i2c_trans;

    function void set_configuration(i2c_configuration cfg);
        configuration = cfg;
    endfunction

    virtual task bl_put(T trans);
        bit temp_op;
        bit [7:0] temp_data[];
        bit temp_complete;
        /* $display({get_full_name()," ",trans.convert2string()}); */

        bus.wait_for_i2c_transfer(temp_op, temp_data);
        if ( trans.op_type == 1 )
        begin
            bus.provide_read_data(trans.data, temp_complete);
        end
    endtask

endclass
