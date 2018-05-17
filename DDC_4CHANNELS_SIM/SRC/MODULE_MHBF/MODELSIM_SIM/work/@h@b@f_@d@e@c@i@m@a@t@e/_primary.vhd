library verilog;
use verilog.vl_types.all;
entity HBF_DECIMATE is
    generic(
        COEFF_WIDTH     : integer := 24;
        DATA_WIDTH      : integer := 24;
        DIFF_DEFAULT    : integer := 2
    );
    port(
        CLK             : in     vl_logic;
        nRST            : in     vl_logic;
        Data_In         : in     vl_logic_vector;
        Data_In_Valid   : in     vl_logic;
        Data_Out        : out    vl_logic_vector;
        Data_Out_Valid  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of COEFF_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DIFF_DEFAULT : constant is 1;
end HBF_DECIMATE;
