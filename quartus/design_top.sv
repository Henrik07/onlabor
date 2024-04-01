module design_top(
    input clk, // The master clock for this module
    input rst_n, // Synchronous reset.
    input rx, // Incoming serial line
    output tx, // Outgoing serial line
    output [7:0] rx_byte, // Byte received
	 output debug_output
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

	/*always @(posedge clk) begin
		transmit = received;
		if (transmit) begin
			tx_byte = rx_byte;
		end
	end*/
	
    uart i_uart(
        .clk(clk),
        .rst(rst_n),
        .rx(rx),
        .tx(tx),
        .transmit(received_q),
        .tx_byte(rx_store_q),
        .received(received),
        .rx_byte(rx_byte_internal),
        .is_receiving(is_receiving),
        .is_transmitting(is_transmitting),
        .recv_error(recv_error)
    );
	 
	 //assign received 		= received_q;
	 assign rx_byte 		= rx_store_q;
	 assign debug_output = debug_q;
	 
	 cmd_int i_cmd_int(
		  .clk(clk),
        .rst_n(rst_n),
		  .data_received(received), 		// <- uart: received
        .data_in(rx_byte_internal),		// <- uart: rx_byte
        .data_valid(received_q),			// -> uart: transmit
        .data_out(rx_store_q),			// -> uart: tx_byte
		  .read_received(read_received),	// <- reg_top: data_valid 
        .read_data(read_data),			// <- reg top: data_out
		  .write_valid(write_valid),		// -> reg top: data_received
		  .write_data(write_data),			// -> reg top: data_in
        .address(address),					// -> reg top: address
		  .wr(wr)								// -> reg top: wr
	 );
	 
	 reg_top i_reg_top(
		  .clk(clk),
		  .rst_n(rst_n),
		  .data_received(write_valid),	// <- cmd_int: write_valid
		  .data_in(write_data),				// <- cmd_int: write_data
	     .data_valid(read_received),		// -> cmd_int: read_received 
		  .data_out(read_data),				// -> cmd_int: read_data
		  .address(address),					// <- cmd_int: address
		  .wr(wr)								// <- cmd_int: wr
	 );
	 
endmodule
