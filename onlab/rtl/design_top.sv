module design_top(
    input clk_i, // The master clock for this module
    input rst_n_i, // Synchronous reset.
    input rx_i, // Incoming serial line
    output tx_o, // Outgoing serial line
    output [7:0] rx_byte_o, // Byte received
	 output debug_output_o
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
logic wr;
logic read_received;
logic write_valid;
logic [7:0] read_data;
logic [7:0] write_data;
logic [6:0] address;
logic [7:0] data_out_cmd;

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

  always_ff @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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
	
    uart i_uart(
        .clk(clk_i),
        .rst(rst_n_i),
        .rx(rx_i),
        .tx(tx_o),
        .transmit(received_q),				// <- cmd_int: data_valid
        .tx_byte(rx_store_q),					// <- cmd_int: data_out
        .received(received),					// -> cmd_int: data_received
        .rx_byte(rx_byte_internal),			// -> cmd_int: data_in
        .is_receiving(is_receiving),
        .is_transmitting(is_transmitting),
        .recv_error(recv_error)
    );
	 
	 //assign received 		= received_q;
	 assign rx_byte 		= rx_store_q;
	 assign debug_output = debug_q;
	 
	 cmd_int i_cmd_int(
		  .clk_i(clk_i),
        .rst_n_i(rst_n_i),
		  .data_received_i(received), 		// <- uart: received
        .data_i(rx_byte_internal),			// <- uart: rx_byte
        .data_valid_o(received_q),			// -> uart: transmit
        .data_o(rx_byte_internal),			// -> uart: tx_byte
		  .read_received_i(read_received),	// <- reg_top: data_valid 
        .read_data_i(read_data),				// <- reg top: data_out
		  .write_valid_o(write_valid),		// -> reg top: data_received
		  .write_data_o(write_data),			// -> reg top: data_in
        .address_o(address),					// -> reg top: address
		  .wr_o(wr)									// -> reg top: wr
	 );
	 
	 reg_top i_reg_top(
		  .clk_i(clk),
		  .rst_n_i(rst_n),
		  .data_received_i(write_valid),		// <- cmd_int: write_valid
		  .data_i(write_data),					// <- cmd_int: write_data
	     .data_valid_o(read_received),		// -> cmd_int: read_received 
		  .data_o(read_data),					// -> cmd_int: read_data
		  .address_i(address),					// <- cmd_int: address
		  .wr_i(wr)									// <- cmd_int: wr
	 );
	 
endmodule
