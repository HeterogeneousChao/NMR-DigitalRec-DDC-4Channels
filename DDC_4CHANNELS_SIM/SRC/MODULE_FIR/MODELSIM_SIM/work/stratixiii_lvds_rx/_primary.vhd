library verilog;
use verilog.vl_types.all;
entity stratixiii_lvds_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        enable_dpa_mode : string  := "OFF";
        data_align_rollover: vl_notype;
        lose_lock_on_one_change: string  := "OFF";
        reset_fifo_at_first_lock: string  := "ON";
        x_on_bitslip    : string  := "ON";
        rx_align_data_reg: string  := "RISING_EDGE";
        enable_soft_cdr_mode: string  := "OFF";
        sim_dpa_output_clock_phase_shift: integer := 0;
        sim_dpa_is_negative_ppm_drift: string  := "OFF";
        sim_dpa_net_ppm_variation: integer := 0;
        enable_dpa_align_to_rising_edge_only: string  := "OFF";
        enable_dpa_initial_phase_selection: string  := "OFF";
        dpa_initial_phase_value: integer := 0;
        registered_output: string  := "ON";
        use_external_pll: string  := "OFF";
        use_dpa_calibration: integer := 0;
        enable_clock_pin_mode: string  := "UNUSED";
        ARRIAII_RX_STYLE: integer := 0;
        STRATIXV_RX_STYLE: integer := 0;
        REGISTER_WIDTH  : vl_notype
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_reset        : in     vl_logic_vector;
        rx_fastclk      : in     vl_logic;
        rx_slowclk      : in     vl_logic;
        rx_enable       : in     vl_logic;
        rx_dpll_reset   : in     vl_logic_vector;
        rx_dpll_hold    : in     vl_logic_vector;
        rx_dpll_enable  : in     vl_logic_vector;
        rx_fifo_reset   : in     vl_logic_vector;
        rx_channel_data_align: in     vl_logic_vector;
        rx_cda_reset    : in     vl_logic_vector;
        rx_out          : out    vl_logic_vector;
        rx_dpa_locked   : out    vl_logic_vector;
        rx_cda_max      : out    vl_logic_vector;
        rx_divfwdclk    : out    vl_logic_vector;
        rx_locked       : in     vl_logic;
        rx_dpa_lock_reset: in     vl_logic_vector;
        rx_dpaclock     : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of number_of_channels : constant is 1;
    attribute mti_svvh_generic_type of deserialization_factor : constant is 1;
    attribute mti_svvh_generic_type of enable_dpa_mode : constant is 1;
    attribute mti_svvh_generic_type of data_align_rollover : constant is 3;
    attribute mti_svvh_generic_type of lose_lock_on_one_change : constant is 1;
    attribute mti_svvh_generic_type of reset_fifo_at_first_lock : constant is 1;
    attribute mti_svvh_generic_type of x_on_bitslip : constant is 1;
    attribute mti_svvh_generic_type of rx_align_data_reg : constant is 1;
    attribute mti_svvh_generic_type of enable_soft_cdr_mode : constant is 1;
    attribute mti_svvh_generic_type of sim_dpa_output_clock_phase_shift : constant is 1;
    attribute mti_svvh_generic_type of sim_dpa_is_negative_ppm_drift : constant is 1;
    attribute mti_svvh_generic_type of sim_dpa_net_ppm_variation : constant is 1;
    attribute mti_svvh_generic_type of enable_dpa_align_to_rising_edge_only : constant is 1;
    attribute mti_svvh_generic_type of enable_dpa_initial_phase_selection : constant is 1;
    attribute mti_svvh_generic_type of dpa_initial_phase_value : constant is 1;
    attribute mti_svvh_generic_type of registered_output : constant is 1;
    attribute mti_svvh_generic_type of use_external_pll : constant is 1;
    attribute mti_svvh_generic_type of use_dpa_calibration : constant is 1;
    attribute mti_svvh_generic_type of enable_clock_pin_mode : constant is 1;
    attribute mti_svvh_generic_type of ARRIAII_RX_STYLE : constant is 1;
    attribute mti_svvh_generic_type of STRATIXV_RX_STYLE : constant is 1;
    attribute mti_svvh_generic_type of REGISTER_WIDTH : constant is 3;
end stratixiii_lvds_rx;
