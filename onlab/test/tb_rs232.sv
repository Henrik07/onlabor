`timescale 1ns / 1ps

module tb_rs232 ();

    logic clk; // The master clock for this module
    logic rst; // Synchronous reset.
    logic rx; // Incoming serial line
    logic tx; // Outgoing serial line
    logic transmit; // Signal to transmit
    logic [7:0] tx_byte; // Byte to transmit
    logic received; // Indicated that a byte has been received.
    logic [7:0] rx_byte; // Byte received
    logic is_receiving; // Low when receive line is idle.
    logic is_transmitting; // Low when transmit line is idle.
    logic recv_error; // Indicates error in receiving packet.

    design_top i_design_top(
        .clk(clk),
        .rst_n(rst),
        .rx(rx),
        .tx(tx),
        .transmit(transmit),
        .tx_byte(tx_byte),
        .received(received),
        .rx_byte(rx_byte),
        .is_receiving(is_receiving),
        .is_transmitting(is_transmitting),
        .recv_error(recv_error)
    );

    always #10ns clk = ~clk;

    always @(posedge clk) begin
	transmit = received;
        if (transmit) begin
            tx_byte <= rx_byte;
        end
    end    

//  1/9600~=104us
    initial begin
        clk = 1'b1;
        rst = 1'b0;
        #5ns;
        rst = 1'b1;
        #15ns;
        rx = 1'b0; //start bit
        #104us;
        rx = 1'b1; //1. data bit
        #104us;
        rx = 1'b0; //2. data bit
        #104us;
        rx = 1'b1; //3. data bit
        #104us;
        rx = 1'b0; //4. data bit
        #104us;
        rx = 1'b1; //5. data bit
        #104us;
        rx = 1'b0; //6. data bit
        #104us;
        rx = 1'b1; //7. data bit
        #104us;
        rx = 1'b0; //8. data bit
        #104us;
        rx = 1'b1; //stop bit
    end

endmodule
