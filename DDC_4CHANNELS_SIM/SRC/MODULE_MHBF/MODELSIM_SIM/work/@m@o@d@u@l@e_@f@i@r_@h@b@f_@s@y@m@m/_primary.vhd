library verilog;
use verilog.vl_types.all;
entity MODULE_FIR_HBF_SYMM is
    generic(
        NMHBF_MAX       : integer := 5;
        COEFF_WIDTH     : integer := 24;
        INPUT_WIDTH     : integer := 24;
        OUTPUT_WIDTH    : integer := 24;
        DATA_WIDTH      : integer := 24;
        FILTER_MAX_ORDER: integer := 32;
        MULT_OUTPUT_WIDTH: integer := 49;
        ADDER_OUTPUT_WIDTH: integer := 54
    );
    port(
        CLK             : in     vl_logic;
        nRST            : in     vl_logic;
        isConfig        : in     vl_logic;
        isConfigACK     : out    vl_logic;
        isConfigDone    : out    vl_logic;
        Data_Config_In  : in     vl_logic_vector;
        MHBF_CTL        : in     vl_logic_vector;
        MHBF_CTL_idx    : in     vl_logic_vector(3 downto 0);
        Data_In         : in     vl_logic_vector;
        Data_In_Valid   : in     vl_logic;
        Data_Out        : out    vl_logic_vector;
        Data_Out_Valid  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NMHBF_MAX : constant is 1;
    attribute mti_svvh_generic_type of COEFF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of INPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FILTER_MAX_ORDER : constant is 1;
    attribute mti_svvh_generic_type of MULT_OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDER_OUTPUT_WIDTH : constant is 1;
end MODULE_FIR_HBF_SYMM;
