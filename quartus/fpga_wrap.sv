module fpga_wrap(
    input clk, // The master clock for this module
    input rst_n, // Synchronous reset.
    input rx, // Incoming serial line
    output tx, // Outgoing serial line
    output [7:0] led_g, // Byte received
    output led_r
);

    design_top i_design_top(
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .tx(tx),
        .rx_byte(led_g),
	.debug_output(led_r)
    );
	 
endmodule
