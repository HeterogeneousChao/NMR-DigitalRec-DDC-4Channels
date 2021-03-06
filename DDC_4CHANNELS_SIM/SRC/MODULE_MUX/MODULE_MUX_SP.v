///////////////////////////////////////////////////////////////////////////////////
////  MODULE MUX SERIAL -> PARALLEL
////				MODULE_MUX_SP
////         							ZHAOCHAO
////									 			20180507
///////////////////////////////////////////////////////////////////////////////////////////
////

module MODULE_MUX_SP(
	CLK, nRST,

	Data_In,
	Data_In_Valid,
	Data_In_ChIdx,
	
	Data_Out_I,
	Data_Out_I_Valid,
	Data_Out_Q,
	Data_Out_Q_Valid
);
	
	parameter INPUT_WIDTH   = 24;
	parameter OUTPUT_WIDTH  = 24;
	
	parameter DATA_OUT_CLK_NUM = 4;
	parameter SP_DATA_OUT_CLK_NUM = (DATA_OUT_CLK_NUM * 2);
	
	input  CLK;
	input  nRST;
	
	input  Data_In_Valid;
	input  [3:0]Data_In_ChIdx;
	input  signed [INPUT_WIDTH-1:0] Data_In;
	
	output  Data_Out_I_Valid;
	output  Data_Out_Q_Valid;

	output  signed [OUTPUT_WIDTH-1:0] Data_Out_I;
	output  signed [OUTPUT_WIDTH-1:0] Data_Out_Q;
	
	reg  rFIFOI_wreq;
	reg  rFIFOQ_wreq;
	
	wire  wFIFOI_full;
	wire  wFIFOQ_full;
	
	
///////////////////////////////////////////////////////////////////////////////////////////
//// Write Data to FIFO 
	reg  rFIFOI_wreq_clk;
	reg  rFIFOI_wreq_datv;
	reg  rFIFOQ_wreq_clk;
	reg  rFIFOQ_wreq_datv;
	
	reg signed [INPUT_WIDTH-1:0] rFIFO_data_wr;
	reg [3:0] rData_In_ChIdx_reg;
	
	// negedge Data_In_Valid, capture the data;
	always @(negedge nRST or negedge Data_In_Valid)
		if(!nRST)
			begin
				rData_In_ChIdx_reg <= 4'd0; 		// default 0;
				rFIFO_data_wr <= {INPUT_WIDTH{1'b0}};
			end
		else
			begin
				rData_In_ChIdx_reg <= (Data_In_ChIdx);
				rFIFO_data_wr <= Data_In;
			end
	// I channel
	// posedge Data_In_Valid, valid the fifo write req;
	always @(negedge nRST or posedge Data_In_Valid)
		if(!nRST)
			begin
				rFIFOI_wreq_datv <= 1'b0;
			end
		else
			if (wFIFOI_full)
				begin
					// fifo full;
				end
			else 
				begin
					if (rData_In_ChIdx_reg == 1)  // I channel: rData_In_ChIdx_reg = 1;
						begin
							rFIFOI_wreq_datv <= ~rFIFOI_wreq_datv;
						end
				end	
	always @(posedge CLK or negedge nRST)
		if (!nRST)
			begin
				rFIFOI_wreq_clk <= 1'b1;
			end
		else
			begin
				if (rFIFOI_wreq_clk == rFIFOI_wreq_datv)
					begin
						rFIFOI_wreq_clk = ~rFIFOI_wreq_clk;
					end
			end
	always @(negedge CLK or negedge nRST)
		if (!nRST)
			begin
				rFIFOI_wreq <= 1'b0;
			end
		else
			begin
				if ((rFIFOI_wreq_clk == rFIFOI_wreq_datv))
					begin
						rFIFOI_wreq = 1'b1;
					end
				else
					begin
						rFIFOI_wreq = 1'b0;
					end
			end		
	// Q channel
	// posedge Data_In_Valid, valid the fifo write req;
	always @(negedge nRST or posedge Data_In_Valid)
		if(!nRST)
			begin
				rFIFOQ_wreq_datv <= 1'b0;
			end
		else
			if (wFIFOI_full)
				begin
					// fifo full;
				end
			else 
				begin
					if (rData_In_ChIdx_reg == 2)  // Q channel: rData_In_ChIdx_reg = 2;	
						begin
							rFIFOQ_wreq_datv <= ~rFIFOQ_wreq_datv;
						end
				end	
	always @(posedge CLK or negedge nRST)
	if (!nRST)
		begin
			rFIFOQ_wreq_clk <= 1'b1;
		end
	else
		begin
			if (rFIFOQ_wreq_clk == rFIFOQ_wreq_datv)
				begin
					rFIFOQ_wreq_clk = ~rFIFOQ_wreq_clk;
				end
		end		
	always @(negedge CLK or negedge nRST)
		if (!nRST)
			begin
				rFIFOQ_wreq <= 1'b0;
			end
		else
			begin
				if ((rFIFOQ_wreq_clk == rFIFOQ_wreq_datv))
					begin
						rFIFOQ_wreq = 1'b1;
					end
				else
					begin
						rFIFOQ_wreq = 1'b0;
					end
			end	

///////////////////////////////////////////////////////////////////////////////////////////
//// Read data from FIFO and output	
	
	wire  wempty_sig_I;
	wire  wempty_sig_Q;
	
	wire [3:0]  wusedw_I;
	wire [3:0]  wusedw_Q;
	
	wire signed [OUTPUT_WIDTH-1:0] wFIFOI_data_rd;
	wire signed [OUTPUT_WIDTH-1:0] wFIFOQ_data_rd;

	
	reg  rFIFOI_rdeq;
	reg signed [OUTPUT_WIDTH-1:0] rData_Out_I_reg;
	
	reg [7:0] cnt_divClk_i_reg;
	reg [2:0] state_idx_i_reg;
	// data distribute;
	// I Channel 
	always @(negedge CLK or negedge nRST)
		if(!nRST)
			begin
				rFIFOI_rdeq <= 1'b0;
				rData_Out_I_reg <= {OUTPUT_WIDTH{1'b0}};
				
				cnt_divClk_i_reg <= 8'd0;
				state_idx_i_reg  <= 3'd0;
			end
		else
			case(state_idx_i_reg)
				3'd0:
					begin
						// fifo half full trig data output  
						if (!wempty_sig_I)
							begin
								cnt_divClk_i_reg <= 8'd0;
								rFIFOI_rdeq 	 <= 1'b1;
								state_idx_i_reg  <= state_idx_i_reg + 1;
							end
					end
				3'd1:
					begin
						rFIFOI_rdeq     <= 1'b0;
						rData_Out_I_reg <= wFIFOI_data_rd;
						if (cnt_divClk_i_reg == SP_DATA_OUT_CLK_NUM) 
							begin
								cnt_divClk_i_reg <= 8'd0;
								state_idx_i_reg  <= 3'd0;
							end
						else
							begin
								cnt_divClk_i_reg <= cnt_divClk_i_reg + 1;
							end
					end
				default:
					begin
						state_idx_i_reg <= 3'd0;
					end
				
			endcase		
	// Q Channel
	reg rFIFOQ_rdeq;
	reg signed [OUTPUT_WIDTH-1:0] rData_Out_Q_reg;
	
	reg [7:0] cnt_divClk_q_reg;
	reg [2:0] state_idx_q_reg;
	
	always @(negedge CLK or negedge nRST)
		if(!nRST)
			begin
				rFIFOQ_rdeq <= 1'b0;
				rData_Out_Q_reg  <= {OUTPUT_WIDTH{1'b0}};
				
				cnt_divClk_q_reg <= 8'd0;
				state_idx_q_reg  <= 3'd0;
			end
		else
			case(state_idx_q_reg)
				3'd0:
					begin
						// fifo half full trig data output  
						if (!wempty_sig_Q)
							begin
								rFIFOQ_rdeq <= 1'b1;
								cnt_divClk_q_reg <= 8'd0;
								state_idx_q_reg  <= state_idx_q_reg + 1;
							end
					end		
				3'd1:
					begin
						rFIFOQ_rdeq   <= 1'b0;
						rData_Out_Q_reg <= wFIFOQ_data_rd;
						if (cnt_divClk_q_reg == (SP_DATA_OUT_CLK_NUM)) 
							begin
								cnt_divClk_q_reg <= 8'd0;
								state_idx_q_reg  <= 3'd0;
							end
						else
							begin
								cnt_divClk_q_reg <= cnt_divClk_q_reg + 1;
							end
					end
				default:
					begin
						state_idx_q_reg <= 3'd0;
					end
				
			endcase
///////////////////////////////////////////////////////////////////////////
//// output align 
// I Channel
	reg [2:0] align_state_i_idx_reg;
	reg rData_Out_I_Valid;
	reg signed [OUTPUT_WIDTH-1:0] rData_Out_I;
	
	always @( posedge CLK or negedge nRST)
		if (!nRST)
			begin
				rData_Out_I_Valid <= 1'b0;
				rData_Out_I <= {OUTPUT_WIDTH{1'b0}};
				
				align_state_i_idx_reg <= 3'd0;
			end
		else
			case(align_state_i_idx_reg)
				3'd0:
					begin
						rData_Out_I_Valid <= 1'b0;
						if ( rFIFOI_rdeq)  
							begin
								align_state_i_idx_reg <= 3'd1;
							end
					end
				3'd1: // I Channel;
					begin
						rData_Out_I_Valid <= 1'b1;
						rData_Out_I <= rData_Out_I_reg;
						align_state_i_idx_reg <= align_state_i_idx_reg + 1; 
					end
				3'd2:
					begin
						rData_Out_I_Valid <= 1'b0;
						align_state_i_idx_reg <= 3'd0;
					end
				default:
					begin
						align_state_i_idx_reg <= 3'd0;
					end
					
					
			endcase

	assign Data_Out_I = rData_Out_I;
	assign Data_Out_I_Valid = rData_Out_I_Valid;

// Q Channel
	reg [2:0] align_state_q_idx_reg;
	reg rData_Out_Q_Valid;
	reg signed [OUTPUT_WIDTH-1:0] rData_Q_Out;
	
	always @( posedge CLK or negedge nRST)
		if (!nRST)
			begin
				rData_Out_Q_Valid <= 1'b0;
				rData_Q_Out <= {OUTPUT_WIDTH{1'b0}};
				
				align_state_q_idx_reg <= 3'd0;
			end
		else
			case(align_state_q_idx_reg)
				3'd0:
					begin
						rData_Out_Q_Valid <= 1'b0;
						if ( rFIFOQ_rdeq)  
							begin
								align_state_q_idx_reg <= 3'd1;
							end
					end
				3'd1: // I Channel;
					begin
						rData_Out_Q_Valid <= 1'b1;
						rData_Q_Out <= rData_Out_Q_reg;
						align_state_q_idx_reg <= align_state_q_idx_reg + 1; 
					end
				3'd2:
					begin
						rData_Out_Q_Valid <= 1'b0;
						align_state_q_idx_reg <= 3'd0;
					end
				default:
					begin
						align_state_q_idx_reg <= 3'd0;
					end
			endcase
		
	assign Data_Out_Q = rData_Q_Out;
	assign Data_Out_Q_Valid = rData_Out_Q_Valid;
	
///////////////////////////////////////////////////////////////////////////
//// FIFO instance
	
	FIFO_24BIT16WS_IP	fifo_24bit16ws_ip_i_inst (
		.clock ( CLK ),
		.data ( rFIFO_data_wr ),
		.rdreq ( rFIFOI_rdeq ),
		.wrreq ( rFIFOI_wreq ),
		.empty ( wempty_sig_I ),
		.full ( wFIFOI_full ),
		.q ( wFIFOI_data_rd ),
		.usedw ( wusedw_I )
	);
	

	FIFO_24BIT16WS_IP	fifo_24bit16ws_ip_q_inst (
		.clock ( CLK ),
		.data ( rFIFO_data_wr ),
		.rdreq ( rFIFOQ_rdeq ),
		.wrreq ( rFIFOQ_wreq ),
		.empty ( wempty_sig_Q ),
		.full ( wFIFOQ_full ),
		.q ( wFIFOQ_data_rd ),
		.usedw ( wusedw_Q )
	);
	

endmodule

