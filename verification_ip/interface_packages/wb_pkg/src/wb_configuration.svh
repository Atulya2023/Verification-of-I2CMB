class wb_configuration extends ncsu_configuration;

    bit collect_coverage;

    covergroup wb_configuration_cg;
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
