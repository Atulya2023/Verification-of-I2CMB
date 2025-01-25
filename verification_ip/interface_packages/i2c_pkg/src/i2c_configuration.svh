class i2c_configuration extends ncsu_configuration;

    bit enable;
    bit [4:0] bit_width;

    covergroup i2c_configuration_cg;
        option.per_instance = 1;
        option.name = name;
    endgroup

    function new(string name=""); 
        super.new(name);
    endfunction

    virtual function string convert2string();
        return {super.convert2string};
    endfunction

endclass
