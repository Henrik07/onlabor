module fpga_wrap(
    input clk_i, // The master clock for this module
    input rst_n_i, // Synchronous reset.
    input rx_i, // Incoming serial line
    output tx_o, // Outgoing serial line
    output [7:0] led_g_o, // Byte received
	 output led_r_o
);

    design_top i_design_top(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .rx_i(rx_i),
        .tx_o(tx_o),
        .rx_byte_o(led_g_o),
		  .debug_o(led_r_o)
    );
	 
endmodule
