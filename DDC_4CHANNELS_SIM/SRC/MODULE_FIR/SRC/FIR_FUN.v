///////////////////////////////////////////////////////////////////////////////////
////  FIR FILTER PIPELINE
////         					ZHAOCHAO
////									 20180408
///////////////////////////////////////////////////////////////////////////////////////////
////  Modified support multichannel, Max 16 channels;
////								ZHAOCHAO 
////									 20180507
///////////////////////////////////////////////////////////////////////////////////////////
////
module FIR_FUN (
	CLK, 
	nRST,
	isConfig,
	isConfigACK,
	isConfigDone,
	Data_Config_In,
	
	Data_In,
	Data_In_Valid,
	Data_In_ChIdx,
	Data_Out,
	Data_Out_Valid,
	Data_Out_ChIdx
);

	parameter COEFF_WIDTH   	  =  24;
	parameter INPUT_WIDTH   	  =  24;
	parameter OUTPUT_WIDTH  	  =  24;
	parameter MULT_OUTPUT_WIDTH  =  49;
	parameter ADDER_OUTPUT_WIDTH =  64;
	parameter FILTER_MULTER_NUM  =  24;
	parameter FIR_MAX_CHANNELS	  =  2;
	parameter MULT_ITERATION_NUM =  5;
	parameter FILTER_MAX_ORDER   =  256;
	
	parameter FIR_FUN_DATA_OUT_VALID_SHIFT = 9;
	
	parameter FILTER_MAX_ORDER_HALF = FILTER_MAX_ORDER / 2;
	//parameter MULT_ITERATION_NUM = FILTER_MAX_ORDER_HALF / FILTER_MULTER_NUM;
	parameter MULT_REMAIN_ITERATION_NUM = (FILTER_MAX_ORDER_HALF - (MULT_ITERATION_NUM*FILTER_MULTER_NUM))+1;

	parameter DATA_REG_NUM       = FIR_MAX_CHANNELS * (FILTER_MAX_ORDER+1);

	input  CLK; 				// >= 23 * signal rate
	input  nRST;

	input  isConfig;
	input  [COEFF_WIDTH-1:0] Data_Config_In;
	output isConfigACK;
	output isConfigDone;

	input  Data_In_Valid;
	output Data_Out_Valid;
	
	input  [3:0]Data_In_ChIdx;
	output [3:0]Data_Out_ChIdx;
	
	input  signed [INPUT_WIDTH-1:0]  Data_In; 
	output signed [OUTPUT_WIDTH-1:0] Data_Out;

	// coef ram
	reg signed [COEFF_WIDTH-1:0] Coeff_Reg[(FILTER_MAX_ORDER+1):0];

	reg [9:0]ridx_i;
	reg [9:0]ridx_j;

	reg [12:0]ridx_k;
	reg [12:0]ridx_a;
	
	reg [9:0]ridx_b;
	reg [9:0]ridx_c;

	reg risConfigACK;
	reg risConfigDone;

	reg [3:0] state_idx_reg;
	reg [9:0] idx_config_data_cnt;

	always @(posedge CLK or negedge nRST)
		if (!nRST)
			begin
				state_idx_reg <= 4'd0;
				risConfigACK  <= 1'b0;
				risConfigDone <= 1'b0;
				idx_config_data_cnt <= 10'd0;
				
				for (ridx_c = 0; ridx_c < (FILTER_MAX_ORDER+2); ridx_c = ridx_c + 1)
					begin
						Coeff_Reg[ridx_c] = {COEFF_WIDTH{1'b0}};
					end
			end
		else
			begin
				case (state_idx_reg)
					4'd0:
						if (isConfig)
							begin
								state_idx_reg <= state_idx_reg + 1;
								risConfigACK  <= 1'b1;
							end
					4'd1:
						if (idx_config_data_cnt == (FILTER_MAX_ORDER+2))
							begin
								idx_config_data_cnt <= 10'd0;
								state_idx_reg <= state_idx_reg + 1;
							end
						else	
							begin
								Coeff_Reg[idx_config_data_cnt] <= Data_Config_In;
								idx_config_data_cnt <= idx_config_data_cnt + 1;
							end
					4'd2:
						begin
							risConfigACK  <= 1'b0;
							risConfigDone <= 1'b1;
							state_idx_reg <= state_idx_reg + 1;
						end
						
					4'd3:
						begin
							risConfigDone <= 1'b0;
							state_idx_reg <= state_idx_reg + 1;
						end
					4'd4: 	// normal work state;
						if (isConfig)
							begin
								state_idx_reg <= 4'd1;
								risConfigACK  <= 1'b1;
							end
					default:
						//NULL
						state_idx_reg <= 4'd0;
				endcase
			end

	assign isConfigACK  = risConfigACK;
	assign isConfigDone = risConfigDone;

	
	reg [3:0]rData_Out_ChIdx;
	reg [3:0]curInChannelIdx_reg;
	

	reg [4:0]ridx_e;
	
	// Data move register
	// negedge Data_In_Valid, get the data;  Data_In_Reg[chIdx][order]
	reg signed[INPUT_WIDTH-1:0] Data_In_Reg[DATA_REG_NUM:0];
	reg isDataIn_reg;

	always @( negedge nRST or negedge Data_In_Valid)
		if (!nRST)
			begin
				isDataIn_reg <= 1'b0;
				curInChannelIdx_reg <= 4'd0;
				for (ridx_a = 0; ridx_a < (DATA_REG_NUM+1); ridx_a = ridx_a + 1)
					begin
						Data_In_Reg[ridx_a] = {INPUT_WIDTH{1'b0}};		
					end
			end
		else
			if (state_idx_reg == 4'd4)
				begin 
					isDataIn_reg <= ~isDataIn_reg;
					curInChannelIdx_reg <= Data_In_ChIdx;
					for (ridx_j = 0; ridx_j < (FILTER_MAX_ORDER); ridx_j = ridx_j + 1)
						begin
							Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+ridx_j+1] <= Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+ridx_j];
						end
					Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))] <= Data_In;
				end
			
	
	reg signed [INPUT_WIDTH:0]Adder_Reg[(FIR_MAX_CHANNELS*(FILTER_MAX_ORDER_HALF+1))-1:0];

	always @( negedge nRST or negedge Data_In_Valid)
		if (!nRST)
			begin
				for (ridx_k = 0; ridx_k < ((FILTER_MAX_ORDER_HALF+1)*FIR_MAX_CHANNELS); ridx_k = ridx_k + 1)
					Adder_Reg[ridx_k] = {(INPUT_WIDTH+1){1'b0}};
			end
		else
			if (state_idx_reg == 4'd4)
				if (Coeff_Reg[FILTER_MAX_ORDER+1])
					begin
						for (ridx_i = 0; ridx_i < FILTER_MAX_ORDER_HALF; ridx_i = ridx_i + 1) 
							begin
								Adder_Reg[((FILTER_MAX_ORDER_HALF+1)*Data_In_ChIdx)+ridx_i] = {Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+ridx_i][INPUT_WIDTH-1], Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+ridx_i]} 
													+ {Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+((FILTER_MAX_ORDER)-ridx_i)][INPUT_WIDTH-1], Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+((FILTER_MAX_ORDER)-ridx_i)]};
							end
						Adder_Reg[((FILTER_MAX_ORDER_HALF+1)*Data_In_ChIdx)+FILTER_MAX_ORDER_HALF] = {Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+FILTER_MAX_ORDER_HALF][INPUT_WIDTH-1], Data_In_Reg[(Data_In_ChIdx*(FILTER_MAX_ORDER+1))+FILTER_MAX_ORDER_HALF]};
					end
				else
					begin
						for (ridx_i = 0; ridx_i < (FILTER_MAX_ORDER_HALF+1); ridx_i = ridx_i + 1) 
							begin
								Adder_Reg[((FILTER_MAX_ORDER_HALF+1)*Data_In_ChIdx)+ridx_i] = {Data_In_Reg[((FILTER_MAX_ORDER_HALF+1)*Data_In_ChIdx)+ridx_i][INPUT_WIDTH-1], Data_In_Reg[((FILTER_MAX_ORDER_HALF+1)*Data_In_ChIdx)+ridx_i]};
							end
					end
			
	// multi 
	reg   signed [INPUT_WIDTH:0]		 Mult_Adder_Reg [FILTER_MULTER_NUM-1:0];
	reg   signed [COEFF_WIDTH-1:0] 		 Mult_Coeff_Reg [FILTER_MULTER_NUM-1:0];
	wire  signed [MULT_OUTPUT_WIDTH-1:0] wMult_Out [FILTER_MULTER_NUM-1:0];
	
	
	reg signed  [ADDER_OUTPUT_WIDTH-1:0] Sum_reg[FIR_MAX_CHANNELS-1:0];
	reg signed  [ADDER_OUTPUT_WIDTH-1:0] Data_Out_reg;
	
	genvar gidx_mult;
		
	generate 
		for(gidx_mult = 0; gidx_mult < FILTER_MULTER_NUM; gidx_mult = gidx_mult + 1)
			begin : gen_mult_inst
				MULT_24BIT25BIT49BIT_IP lpm_mult_24bit24bit48bit_inst(
					.clock(CLK),
					.dataa(Mult_Coeff_Reg[gidx_mult]),
					.datab(Mult_Adder_Reg[gidx_mult]),
					.result(wMult_Out[gidx_mult])
				);
			end
	endgenerate
	
	reg [2:0] mult_state_idx_reg;
	reg [7:0] idx_mult_cnt;
	reg [7:0] idx_remain_mult_cnt;
	reg  rData_Out_Valid;
	reg  isDataInLast_reg; 
	
	reg [4:0]ridx_d;
	
	always @(posedge CLK or negedge nRST)
		if(!nRST)
			begin
				for (ridx_d = 0; ridx_d < FIR_MAX_CHANNELS; ridx_d = ridx_d + 1)
					begin
						Sum_reg[ridx_d] = {ADDER_OUTPUT_WIDTH{1'b0}};
					end
				for (ridx_b = 0; ridx_b < FILTER_MULTER_NUM; ridx_b = ridx_b+1)
					begin
						Mult_Adder_Reg[ridx_b] <= {(INPUT_WIDTH+1){1'b0}};
						Mult_Coeff_Reg[ridx_b] <= {COEFF_WIDTH{1'b0}};
					end
				
				Data_Out_reg <= {ADDER_OUTPUT_WIDTH{1'b0}};
				rData_Out_ChIdx <= 4'd0;
				
				isDataInLast_reg <= 1'b1;
				idx_mult_cnt     <= 8'd0;
				idx_remain_mult_cnt <= 8'd0;
				rData_Out_Valid <= 1'b0;
				mult_state_idx_reg <= 3'd0;
				
			end
		else
			case (mult_state_idx_reg)
				3'd0:
					begin
						rData_Out_Valid <= 1'b0;
						for (ridx_b = 0; ridx_b < FILTER_MULTER_NUM; ridx_b = ridx_b+1)
							begin
								Mult_Adder_Reg[ridx_b] <= {(INPUT_WIDTH+1){1'b0}};
								Mult_Coeff_Reg[ridx_b] <= {COEFF_WIDTH{1'b0}};
							end
						Sum_reg[curInChannelIdx_reg] = {ADDER_OUTPUT_WIDTH{1'b0}};
						
						if (state_idx_reg == 4'd4)
							begin
								if ( isDataIn_reg == isDataInLast_reg)
									begin
										isDataInLast_reg   <= ~isDataInLast_reg;
										mult_state_idx_reg <= mult_state_idx_reg + 1;
									end
							end
					end
				3'd1:
					if (idx_mult_cnt == (MULT_ITERATION_NUM))
						begin
							idx_mult_cnt <= 8'd0;
							for (ridx_b = 0; ridx_b < FILTER_MULTER_NUM; ridx_b = ridx_b+1)
								begin
									Sum_reg[curInChannelIdx_reg] = Sum_reg[curInChannelIdx_reg] + wMult_Out[ridx_b];
								end
								
							for (idx_remain_mult_cnt = 0; idx_remain_mult_cnt < MULT_REMAIN_ITERATION_NUM; idx_remain_mult_cnt = idx_remain_mult_cnt + 1)
								begin
									Mult_Adder_Reg[idx_remain_mult_cnt] <= Adder_Reg[((FILTER_MAX_ORDER_HALF+1)*curInChannelIdx_reg)+(MULT_ITERATION_NUM*FILTER_MULTER_NUM)+idx_remain_mult_cnt];
									Mult_Coeff_Reg[idx_remain_mult_cnt] <= Coeff_Reg[(MULT_ITERATION_NUM*FILTER_MULTER_NUM)+idx_remain_mult_cnt];
								end
							mult_state_idx_reg <= mult_state_idx_reg + 1;
						end
					else
						begin
							for (ridx_b = 0; ridx_b < FILTER_MULTER_NUM; ridx_b = ridx_b+1)
								begin
									Mult_Adder_Reg[ridx_b] <= Adder_Reg[((FILTER_MAX_ORDER_HALF+1)*curInChannelIdx_reg)+((idx_mult_cnt)*FILTER_MULTER_NUM)+ridx_b];
									Mult_Coeff_Reg[ridx_b] <= Coeff_Reg[((idx_mult_cnt)*FILTER_MULTER_NUM) + ridx_b];
									if (idx_mult_cnt > 1)
										begin
											Sum_reg[curInChannelIdx_reg] = Sum_reg[curInChannelIdx_reg] + wMult_Out[ridx_b];
										end
									idx_mult_cnt <= idx_mult_cnt + 1;
								end
						end
				3'd2:
					begin
						for (ridx_b = 0; ridx_b < FILTER_MULTER_NUM; ridx_b = ridx_b+1)
							begin
								Sum_reg[curInChannelIdx_reg] = Sum_reg[curInChannelIdx_reg] + wMult_Out[ridx_b];
							end
						mult_state_idx_reg <= mult_state_idx_reg + 1;
					end
				3'd3:
					begin
						for (idx_remain_mult_cnt = 0; idx_remain_mult_cnt < MULT_REMAIN_ITERATION_NUM; idx_remain_mult_cnt = idx_remain_mult_cnt + 1)
							begin
								Sum_reg[curInChannelIdx_reg] = Sum_reg[curInChannelIdx_reg] + wMult_Out[idx_remain_mult_cnt];
							end
						rData_Out_ChIdx <= curInChannelIdx_reg;
						Data_Out_reg <= Sum_reg[curInChannelIdx_reg];
						rData_Out_Valid    <= 1'b1;
						mult_state_idx_reg <= 3'd0;
					end
					
				default:
					mult_state_idx_reg <= 3'd0;		
			endcase
			
	// align data out and dataout valid;
	reg [3:0] idx_doutV_delay_cnt;
	always @(posedge Data_In_Valid or negedge nRST)
		if (!nRST)
			begin
				idx_doutV_delay_cnt <= 4'd0;
			end
		else
			begin
				if (idx_doutV_delay_cnt == FIR_FUN_DATA_OUT_VALID_SHIFT)
					begin
						//NULL;
					end
				else
					begin
						idx_doutV_delay_cnt <= idx_doutV_delay_cnt + 1;
					end
			end
				
	assign Data_Out_Valid = ((idx_doutV_delay_cnt == FIR_FUN_DATA_OUT_VALID_SHIFT) ? 
								rData_Out_Valid : {1'b0});
	assign Data_Out = Data_Out_reg;
	assign Data_Out_ChIdx = rData_Out_ChIdx;

endmodule


		
		

	
