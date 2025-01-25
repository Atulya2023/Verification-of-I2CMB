class wb_transaction_base extends ncsu_transaction;
    `ncsu_register_object(wb_transaction_base)

    bit [7:0] data;
    bit [1:0] reg_addr;
    bit wb_op;
    bit intrpt;

    function new(string name=""); 
        super.new(name);
    endfunction

    virtual function string convert2string();
        return {super.convert2string(),$sformatf("Data :0x%x, Reg_addr:0x%x wb_op: %d", data, reg_addr, wb_op)};
    endfunction

    function bit compare(wb_transaction_base rhs);
        return ((this.reg_addr  == rhs.reg_addr) && 
               (this.wb_op == rhs.wb_op) &&
               /* (this.intrpt == rhs.intrpt) && */
               (this.data == rhs.data) );
    endfunction

    virtual function void add_to_wave(int transaction_viewing_stream_h);
        super.add_to_wave(transaction_viewing_stream_h);
        $add_attribute(transaction_view_h,reg_addr,"reg_addr");
        $add_attribute(transaction_view_h,wb_op,"wb_op");
        $add_attribute(transaction_view_h,data,"data");
        /* $add_attribute(transaction_view_h,intrpt,"intrpt"); */
        $end_transaction(transaction_view_h,end_time);
        $free_transaction(transaction_view_h);
    endfunction

endclass
