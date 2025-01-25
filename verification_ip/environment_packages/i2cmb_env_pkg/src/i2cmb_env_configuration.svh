class env_configuration extends ncsu_configuration;
  
  i2c_configuration i2c_agent_config;
  wb_configuration wb_agent_config;

  function new(string name=""); 
    super.new(name);
    i2c_agent_config = new("i2c_agent_config");
    wb_agent_config = new("wb_agent_config");
    wb_agent_config.collect_coverage=0;
    /* wb_agent_config.sample_coverage(); */
    /* wb_agent_config.sample_coverage(); */
  endfunction


endclass
