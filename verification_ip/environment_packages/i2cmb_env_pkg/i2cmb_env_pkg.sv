package i2cmb_pkg;

    import ncsu_pkg::*;
    import wb_pkg::*;
    import i2c_pkg::*;
    `include "../../ncsu_pkg/ncsu_macros.svh"

    `include "src/i2cmb_env_configuration.svh"
    `include "src/i2cmb_predictor.svh"
    `include "src/i2cmb_coverage.svh"
    `include "src/i2cmb_coverage_i2c.svh"
    `include "src/i2cmb_coverage_wb.svh"
    `include "src/i2cmb_scoreboard.svh"
    `include "src/i2cmb_environment.svh"
    `include "src/i2cmb_generator.svh"
    `include "src/i2cmb_generator_reg_test.svh"
    `include "src/i2cmb_testcases.svh"
    `include "src/i2cmb_test_base.svh"

endpackage
