module cmd_int(
	input clk_i,
	input rst_n_i,

	//uart <-> cmd_int
	input data_received_i,
	input [7:0] data_i,
	
	output data_valid_o,
	output [7:0] data_o,
	
	//cmd_int <-> reg_top
	output wr_o,
	output [6:0] address_o,
	
	input read_received_i,
	input [7:0] read_data_i,
	
	output write_valid_o,
	output [7:0] write_data_o
);

/*localparam [2:0]
	IDLE = 3'b000,
	WRITE = 3'b001,
	READ = 3'b010;*/

typedef enum {IDLE, WRITE, READ} cmd_state_e;
	
logic data_valid_d, data_valid_q;
logic write_valid_d, write_valid_q;
logic wr_d, wr_q;
logic [6:0] address_d, address_q;

cmd_state_e cmd_state_d, cmd_state_q;

logic ready;

assign ready = (cmd_state_q == IDLE);

	always_comb begin
		data_valid_d = read_received;
		write_valid_d = data_received;
		wr_d = wr_q;
		address_d = address_q;
		cmd_state_d = cmd_state_q;
		write_data_o = 8'b0;
		data_o = 8'b0;
		if (ready && data_received) begin
			write_valid_d = 0;
			wr_d = data_i[7];
			address_d = data_i[6:0];
		end
		case (cmd_state_q)
			IDLE: begin
				//write_valid <= 0;
				if (wr_o) begin
					cmd_state_d = WRITE;
				end
				else begin
					cmd_state_d = READ;
				end
			end
			WRITE: begin
				if (write_valid_o) begin
					write_data_o = data_i;
					cmd_state_d = IDLE;
				end
			end
			READ: begin
				if (read_received_i) begin
					data_o = read_data_i;
					cmd_state_d = IDLE;
				end
			end
			default: begin
				cmd_state_d = IDLE;
			end
		endcase
	end

	always_ff @(posedge clk_i, negedge rst_n_i) begin
		if (!rst_n_i) begin
			wr_q <= 0; //READ
			address_q <= 7'b0;
			data_valid_q <= 0;
			write_valid_q <= 0;
			cmd_state_q <= IDLE;
		end
		else begin
			if (ready) begin
				wr_q <= wr_d;
				address_q <= address_d;
			end
			data_valid_q <= data_valid_d;
			write_valid_q <= write_valid_d;
			cmd_state_q <= cmd_state_d;
		end
	end
	
	assign data_valid_o = data_valid_q;
	assign write_valid_o = write_valid_q;
	assign wr_o = wr_q;
	assign address_o = address_q;

endmodule
