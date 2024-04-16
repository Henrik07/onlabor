module reg_top(
	input clk_i,
	input rst_n_i,
	
	//reg_top <-> cmd_int
	input [6:0] address_i,
	input wr_i,
	
	input data_received_i,
	input [7:0] data_i,
	
	//output data_valid_o,
	output [7:0] data_o
);

/*localparam [2:0]
	IDLE = 0,
	READ = 1,
	WRITE = 2;*/

typedef enum {IDLE, WRITE, READ} reg_state_e;

reg_state_e reg_state_d, reg_state_q;	
	
logic [7:0] reg_array_d [0:127], reg_array_q [0:127]; //128db 8 bites regiszter
integer i;
integer e;

//logic cs [6:0];

//logic [2:0] next_state = IDLE;

//logic [7:0] data_o_d, data_o_q;

//logic data_valid_d, data_valid_q;

	always_comb begin
		reg_state_d = reg_state_q;
		//data_o_d = 8'b0;
		//data_valid_d = 0;
		for (i = 0; i < 128; i = i + 1) begin
			reg_array_d[i] = reg_array_q[i];
		end
		if (wr_i & data_received_i) begin
			reg_array_d[address_i] = data_i;
		end
		/*case (reg_state_q)
			IDLE: begin
				if (wr_i) begin
					reg_state_d = WRITE;
				end
				else begin
					reg_state_d = READ;
				end
			end
			WRITE: begin
				if (data_received_i) begin
					reg_array[address_i] = data_i;
					reg_state_d = IDLE;
				end
				else begin
					reg_array[address_i] = reg_array[address_i];
				end
			end
			READ: begin
				data_out_d = reg_array[address_i];
				data_valid_d = 1;
				reg_state_d = IDLE;
			end
		endcase*/
	end
		
	always_ff @(posedge clk_i, negedge rst_n_i) begin
		if (!rst_n_i) begin
			//data_o_q <= 8'b0;
			//data_valid_q <= 0;
			for (e = 0; e < 128; e = e + 1) begin
				reg_array_q[e] <= 8'b0;
			end
		end
		else begin
			for (e = 0; e < 128; e = e + 1) begin
				reg_array_q[e] <= reg_array_d[e];
			end
			//data_out_q <= data_out_d;
			//data_valid_q <= data_valid_d;
			//reg_state_q <= reg_state_d;
		end
	end
	
	assign data_o = reg_array_q[address_i];
	//assign data_valid_o = data_valid_q;
	
	/*always_ff @(posedge clk, negedge rst) begin
		if (!rst_n) begin
			next_state <= IDLE;
		end
		case (next_state)
			IDLE: begin
				if (wr) begin
					next_state <= WRITE;
				end
				else begin
					next_state <= READ;
				end
			end
			WRITE: begin
				if (data_received) begin
					reg_array[address] <= data_in;
					next_state <= IDLE;
				end
			end
			READ: begin
				if (cs[address]) begin
					data_valid <= 1;
					data_out <= reg_array[address];
					next_state <= IDLE;
				end
			end
		endcase
	end*/
		
endmodule
