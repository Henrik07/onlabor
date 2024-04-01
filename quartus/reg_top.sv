module reg_top(
	input clk,
	input rst_n,
	input data_received,
	input data_in,
	output data_valid,
	output data_out,
	input address,
	input wr
);

localparam [2:0]
	IDLE = 0,
	READ = 1,
	WRITE = 2;

logic [7:0] reg_array [0:127]; //128db 8 bites regiszter
integer i;

logic [2:0] next_state = IDLE;

	always_comb begin
		if (!wr) begin
			data_out = reg_array[address];
			data_valid = 1;
		end
		else begin
			data_out = 8'b0;
			data_valid = 0;
		end
	end
		
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < 128; i = i + 1) begin
				reg_array[i] = 8'b0;
			end
		end
		else if (wr) begin
			reg_array[address] <= data_in;
		end
		else begin
			reg_array[address] <= reg_array[address];
		end
	end
		
endmodule
