module cmd_int(
	input clk,
	input rst_n,

	//uart <-> cmd_int
	input data_received,
	input [7:0] data_in,
	
	output data_valid,
	output [7:0] data_out,
	
	//cmd_int <-> reg
	output wr,
	output [6:0] address,
	
	input read_received,
	input [7:0] read_data,
	
	output write_valid,
	output [7:0] write_data
);

localparam [2:0]
	IDLE = 0,
	READ = 1,
	WRITE = 2;
	
logic wr_latch;
logic [6:0] address_latch;

logic [2:0] next_state = IDLE;

logic ready;

assign ready = next_state == IDLE;

//assign data_valid = read_received;
//assign write_valid = data_received;

	always_comb begin
		data_valid = read_received;
		write_valid = data_received;
		wr = wr_latch;
		address = address_latch;
		if (ready && data_received) begin
			write_valid = 0;
			wr = data_in[7];
			address = data_in[6:0];
		end
	end

	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			//wr <= 0; //READ
			//address <= 7'b0;
			next_state <= IDLE;
		end
		case (next_state)
			IDLE: begin
				//write_valid <= 0;
				wr_latch <= wr;
				address_latch <= wr;
				if (wr) begin
					next_state <= WRITE;
				end
				else begin
					next_state <= READ;
				end
			end
			WRITE: begin
				if (write_valid) begin
					write_data <= data_in;
					next_state <= IDLE;
				end
				else begin
					write_data <= write_data;
				end
			end
			READ: begin
				if (read_received) begin
					data_out <= read_data;
					next_state <= IDLE;
				end
				else begin
					data_out <= data_out;
				end
			end
		endcase
	end

endmodule
