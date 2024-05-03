`timescale 1ns / 1ps

module tb_design_top ();

    logic clk; // The master clock for this module
    logic rst_n; // Synchronous reset.
    logic rx; // Incoming serial line
    logic rts;
    logic tx; // Outgoing serial line
    logic [7:0] rx_byte; // Byte received
    logic debug_o;

    design_top i_design_top(
        .clk_i(clk),
        .rst_n_i(rst_n),
        .rx_i(rx),
        .rts(rts),
        .tx_o(tx),
        .rx_byte_o(/*rx_byte*/),
        .debug_o(debug_o)
    );

    always #10ns clk = ~clk;

    task automatic rx_read (input [7:0] rx_byte);
        begin
            rx = 1'b0; //start bit
            #104us;
            rx = rx_byte[0]; //1. data bit
            #104us;
            rx = rx_byte[1]; //2. data bit
            #104us;
            rx = rx_byte[2]; //3. data bit
            #104us;
            rx = rx_byte[3]; //4. data bit
            #104us;
            rx = rx_byte[4]; //5. data bit
            #104us;
            rx = rx_byte[5]; //6. data bit
            #104us;
            rx = rx_byte[6]; //7. data bit
            #104us;
            rx = rx_byte[7]; //8. data bit
            #104us;
            rx = 1'b1; //stop bit
        end
    endtask

//  1/9600~=104us
    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        #5ns;
        rst_n = 1'b1;
        #15ns;
        rts = 1'b1;
        @(posedge debug_o);
        rx_byte = 8'b10000001;
        rx_read(rx_byte);
        @(posedge debug_o);
        //@(negedge debug_o);
        //#104us;
        rx_byte = 8'b10101010;
        rx_read(rx_byte);
        @(posedge debug_o);
        //@(negedge debug_o);
        //#104us;
        rx_byte = 8'b00000001;
        rx_read(rx_byte);
    end
    
endmodule
