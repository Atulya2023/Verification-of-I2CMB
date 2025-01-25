class scoreboard extends ncsu_component#(.T(i2c_transaction_base));

    T trans_in;
    T trans_out;

    function new(string name = "", ncsu_component_base  parent = null); 
        super.new(name,parent);
        trans_in = new("trans_in");
    endfunction


    virtual function void nb_transport(input T input_trans, output T output_trans);
        /* $display({get_full_name()," nb_transport: expected transaction ",input_trans.convert2string()}); */
        /* $display("nb_transport called at %t", $time); */
        this.trans_in = input_trans;
        output_trans = trans_out;
    endfunction

    virtual function void nb_put(T trans);
        $display({" Actual transaction ",trans.convert2string()});
        /* $display({get_full_name()," Predicted transaction ",trans_in.convert2string()}); */
        /* $display("nb_put called at %t", $time); */
        /* if ( this.trans_in.compare(trans) ) $display({get_full_name()," i2c_transaction MATCH!\n"}); */
    /* $display({get_full_name()," i2c_transaction MATCH!"}); */
        /* else                                $display({get_full_name()," i2c_transaction MISMATCH!", this.trans_in.convert2string()}); */
        /* else                                $display({get_full_name()," i2c_transaction MISMATCH!"}); */
    endfunction
endclass


