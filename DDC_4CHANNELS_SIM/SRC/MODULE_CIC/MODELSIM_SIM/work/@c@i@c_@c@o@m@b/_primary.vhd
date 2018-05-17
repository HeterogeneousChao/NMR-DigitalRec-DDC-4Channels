library verilog;
use verilog.vl_types.all;
entity CIC_COMB is
    generic(
        MIDDLE_WIDTH    : integer := 37;
        CIC_MAX_NUMSECS : integer := 8;
        CIC_CONFIG_DATA_WIDTH: integer := 16
    );
    port(
        CLK             : in     vl_logic;
        nRST            : in     vl_logic;
        isConfig        : in     vl_logic;
        isConfigDone    : out    vl_logic;
        isCOnfigACK     : out    vl_logic;
        Data_Config_In  : in     vl_logic_vector;
        Data_In         : in     vl_logic_vector;
        Data_In_Valid   : in     vl_logic;
        Data_Out        : out    vl_logic_vector;
        Data_Out_Valid  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MIDDLE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of CIC_MAX_NUMSECS : constant is 1;
    attribute mti_svvh_generic_type of CIC_CONFIG_DATA_WIDTH : constant is 1;
end CIC_COMB;
