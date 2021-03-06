library verilog;
use verilog.vl_types.all;
entity MODULE_DDC_CHANNEL_MUX_FILTERS is
    generic(
        INPUT_WIDTH     : integer := 24;
        OUTPUT_WIDTH    : integer := 24;
        COEF_WIDTH      : integer := 32;
        CIC_MIDDLE_WIDTH: integer := 37;
        CIC_MAX_CHANNELS: integer := 2;
        CIC_CONFIG_DATA_WIDTH: integer := 24;
        CIC_MAX_DCEF    : integer := 16;
        CIC_MAX_DIFFD   : integer := 1;
        CIC_MAX_NUMSECS : integer := 16;
        CIC2_MAX_CHANNELS: integer := 2;
        CICC2_MAX_CHANNELS: integer := 2;
        NMHBF_MAX       : integer := 5;
        MHBF_COEFF_WIDTH: integer := 24;
        MHBF_INPUT_WIDTH: integer := 24;
        MHBF_OUTPUT_WIDTH: integer := 24;
        MHBF_DATA_WIDTH : integer := 24;
        MHBF_FILTER_MAX_ORDER: integer := 32;
        MHBF_MULT_OUTPUT_WIDTH: integer := 49;
        MHBF_ADDER_OUTPUT_WIDTH: integer := 54;
        MHBF_FILTER_MULTER_NUM: integer := 2;
        MHBF_MBF_MAX_CHANNELS: integer := 2;
        FIR_FILTER_MAX_ORDER: integer := 512;
        DFIR_MAX_CHANNELS: integer := 2;
        CIC_CONFIG_DATA_NUM: integer := 3;
        CICC_CONFIG_DATA_NUM: integer := 259;
        MHBF_CONFIG_DATA_NUM: vl_notype;
        DFIR_CONFIG_DATA_NUM: vl_notype
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
        Data_In_ChIdx   : in     vl_logic_vector(3 downto 0);
        Data_Out        : out    vl_logic_vector;
        Data_Out_Valid  : out    vl_logic;
        Data_Out_ChIdx  : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of COEF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of CIC_MIDDLE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of CIC_MAX_CHANNELS : constant is 1;
    attribute mti_svvh_generic_type of CIC_CONFIG_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of CIC_MAX_DCEF : constant is 1;
    attribute mti_svvh_generic_type of CIC_MAX_DIFFD : constant is 1;
    attribute mti_svvh_generic_type of CIC_MAX_NUMSECS : constant is 1;
    attribute mti_svvh_generic_type of CIC2_MAX_CHANNELS : constant is 1;
    attribute mti_svvh_generic_type of CICC2_MAX_CHANNELS : constant is 1;
    attribute mti_svvh_generic_type of NMHBF_MAX : constant is 1;
    attribute mti_svvh_generic_type of MHBF_COEFF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MHBF_INPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MHBF_OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MHBF_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MHBF_FILTER_MAX_ORDER : constant is 1;
    attribute mti_svvh_generic_type of MHBF_MULT_OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MHBF_ADDER_OUTPUT_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MHBF_FILTER_MULTER_NUM : constant is 1;
    attribute mti_svvh_generic_type of MHBF_MBF_MAX_CHANNELS : constant is 1;
    attribute mti_svvh_generic_type of FIR_FILTER_MAX_ORDER : constant is 1;
    attribute mti_svvh_generic_type of DFIR_MAX_CHANNELS : constant is 1;
    attribute mti_svvh_generic_type of CIC_CONFIG_DATA_NUM : constant is 1;
    attribute mti_svvh_generic_type of CICC_CONFIG_DATA_NUM : constant is 1;
    attribute mti_svvh_generic_type of MHBF_CONFIG_DATA_NUM : constant is 3;
    attribute mti_svvh_generic_type of DFIR_CONFIG_DATA_NUM : constant is 3;
end MODULE_DDC_CHANNEL_MUX_FILTERS;
