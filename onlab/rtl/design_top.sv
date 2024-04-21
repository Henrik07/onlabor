module design_top(
    input clk_i, // The master clock for this module
    input rst_n_i, // Synchronous reset.
    input rx_i, // Incoming serial line
    output tx_o, // Outgoing serial line
    output [7:0] rx_byte_o, // Byte received
	output debug_o
);

//uart
logic is_receiving;
logic is_transmitting;
logic recv_error;
logic received;
logic transmit;
logic [7:0] tx_byte;

logic received_q, received_d;
logic [7:0] rx_byte_internal;
logic [7:0] rx_store_q, rx_store_d;

//cmd_int
logic clk_cmd;
logic rst_n_cmd;
logic received_cmd;
logic [7:0] data_in_cmd;
logic data_valid_cmd;
logic [7:0] data_out_cmd;
logic [7:0] read_data_cmd;
logic write_valid_cmd;
logic [7:0] write_data_cmd;
logic [6:0] address_cmd;
logic wr_cmd;


//reg_top
logic clk_reg;
logic rst_n_reg;
logic [7:0] data_received_reg;
logic [7:0] data_in_reg;
logic [7:0] data_out_reg;
logic [6:0] address_reg;
logic wr_reg;


//debug
logic [7:0]	debug_q,debug_d;

	always_comb begin
		rx_store_d = rx_store_q;
		received_d = received;
		debug_d 	= debug_q;
		if ( received ) begin
		 rx_store_d = rx_byte_internal;
		 debug_d 	 = !debug_q;
		end
	end 

	always_ff @ (posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			rx_store_q <=	'0; 
			received_q <= '0;
			debug_q 	<= '0;
		end
		else begin
			rx_store_q <= rx_store_d;
			received_q <=	received_d;
			debug_q 	<=	debug_d;
		end
	 end
	
	assign transmit = data_valid_cmd;
	assign tx_byte = data_out_cmd;
	
   uart i_uart(
       .clk(clk_i),
       .rst(rst_n_i),
       .rx(rx_i),
       .tx(tx_o),
       .transmit(transmit),//received_q),		// <- cmd_int: data_valid
       .tx_byte(tx_byte),//rx_store_q),		// <- cmd_int: data_out
       .received(received),						// -> cmd_int: data_received
       .rx_byte(rx_byte_internal),				// -> cmd_int: data_in
       .is_receiving(is_receiving),
       .is_transmitting(is_transmitting),
       .recv_error(recv_error)
   );
	 
	//assign received 		= received_q;
	assign rx_byte 		= rx_store_q;
	assign debug_output = debug_q;
	
	assign clk_cmd = clk_i;
	assign rst_n_cmd = rst_n_i;
	assign received_cmd = received;
	assign data_in_cmd = rx_byte_internal;
	assign read_data_cmd = data_out_reg;
	 
	 
	cmd_int i_cmd_int(
		.clk_i(clk_cmd),//clk_i),
        .rst_n_i(rst_n_cmd),//rst_n_i),
		.data_received_i(received_cmd),//received), 		// <- uart: received
        .data_i(data_in_cmd),//rx_byte_internal),				// <- uart: rx_byte
        .data_valid_o(data_valid_cmd),//received_q),		// -> uart: transmit
        .data_o(data_out_cmd),//rx_byte_internal),				// -> uart: tx_byte
        .read_data_i(read_data_cmd),//read_data),			// <- reg top: data_out
		.write_valid_o(write_valid_cmd),//write_valid),	// -> reg top: data_received
		.write_data_o(write_data_cmd),//write_data),		// -> reg top: data_in
        .address_o(address_cmd),//address),					// -> reg top: address
		.wr_o(wr_cmd)//wr)										// -> reg top: wr
	);
	 
	assign clk_reg = clk_i;
	assign rst_n_reg = rst_n_i;
	assign data_received_reg = write_valid_cmd;
	assign data_in_reg = write_data_cmd;
	assign address_reg = address_cmd;
	assign wr_reg = wr_cmd;
	 
	reg_top i_reg_top(
		 .clk_i(clk_reg),
		 .rst_n_i(rst_n_reg),
		 .data_received_i(data_received_reg),	// <- cmd_int: write_valid
		 .data_i(data_in_reg),							// <- cmd_int: write_data
		 .data_o(data_out_reg),							// -> cmd_int: read_data
		 .address_i(address_reg),					// <- cmd_int: address
		 .wr_i(wr_reg)									// <- cmd_int: wr
	);
	 
endmodule
