class i2c_transaction_base extends ncsu_transaction;
    `ncsu_register_object(i2c_transaction_base)

    bit start;
    bit op_type;
    bit ack[];
    bit [7:0] data[$];
    bit [6:0] addr;

    function new(string name=""); 
        super.new(name);
    endfunction

    virtual function string convert2string();
        return {super.convert2string(),$sformatf("Address:0x%x Operation:0x%x Data:0x%p", addr, op_type, data)};
    endfunction

    function bit compare(i2c_transaction_base rhs);
        return ((this.op_type  == rhs.op_type ) && 
               (this.addr == rhs.addr) &&
               (this.data == rhs.data) );
    endfunction

    virtual function void add_to_wave(int transaction_viewing_stream_h);
        super.add_to_wave(transaction_viewing_stream_h);
        $add_attribute(transaction_view_h,op_type,"op_type");
        $add_attribute(transaction_view_h,addr,"addr");
        /* $add_attribute(transaction_view_h,data,"data"); */
        $end_transaction(transaction_view_h,end_time);
        $free_transaction(transaction_view_h);
    endfunction

endclass
