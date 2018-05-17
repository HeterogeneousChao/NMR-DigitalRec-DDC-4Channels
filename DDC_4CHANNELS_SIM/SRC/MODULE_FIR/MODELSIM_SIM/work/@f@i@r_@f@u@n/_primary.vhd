library verilog;
use verilog.vl_types.all;
entity FIR_FUN is
    generic(
        COEFF_WIDTH     : integer := 24;
        INPUT_WIDTH     : integer := 24;
        OUTPUT_WIDTH    : integer := 24;
        MULT_OUTPUT_WIDTH: integer := 49;
        ADDER_OUTPUT_WIDTH: integer := 54;
        FILTER_MULTER_NUM: integer := 24;
        MULT_ITERATION_NUM: integer := 5;
        FILTER_MAX_ORDER: integer := 256;
        FILTER_MAX_ORDER_HALF: vl_notype;
        MULT_REMAIN_ITERATION_NUM: vl_notype
    );
    port(
        CLK             : in     vl_logic;
        nRST            : in     vl_logic;
        isConfig        : in     vl_logic;
        isConfigACK     : out    vl_logic;
        isConfigDone    : out    vl_logic;
        Data_Config_In  : in     vl_logic_vector;
        Data_In         : in     vl_logic_vector;
        Data_In_Valid   : in     vl_logic;
        Data_Out        : out    vl_logic_vector;
        Data_Out_Valid  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of COEFF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of INPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MULT_OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDER_OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FILTER_MULTER_NUM : constant is 1;
    attribute mti_svvh_generic_type of MULT_ITERATION_NUM : constant is 1;
    attribute mti_svvh_generic_type of FILTER_MAX_ORDER : constant is 1;
    attribute mti_svvh_generic_type of FILTER_MAX_ORDER_HALF : constant is 3;
    attribute mti_svvh_generic_type of MULT_REMAIN_ITERATION_NUM : constant is 3;
end FIR_FUN;
