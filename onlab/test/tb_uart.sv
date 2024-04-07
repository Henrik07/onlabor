//`uselib lib = modules_lib

`timescale 1ns / 1ps

module tb_uart ();

    logic clk_1; // The master clock for this module
    logic rst_n_1; // Synchronous reset.
    logic rx_1; // Incoming serial line
    logic tx_1; // Outgoing serial line
    logic transmit_1; // Signal to transmit
    logic [7:0] tx_byte_1; // Byte to transmit
    logic received_1; // Indicated that a byte has been received.
    logic [7:0] rx_byte_1; // Byte received
    logic is_receiving_1; // Low when receive line is idle.
    logic is_transmitting_1; // Low when transmit line is idle.
    logic recv_error_1; // Indicates error in receiving packet.

    logic clk_2; // The master clock for this module
    logic rst_n_2; // Synchronous reset.
    logic rx_2; // Incoming serial line
    logic tx_2; // Outgoing serial line
    logic transmit_2; // Signal to transmit
    logic [7:0] tx_byte_2; // Byte to transmit
    logic received_2; // Indicated that a byte has been received.
    logic [7:0] rx_byte_2; // Byte received
    logic is_receiving_2; // Low when receive line is idle.
    logic is_transmitting_2; // Low when transmit line is idle.
    logic recv_error_2; // Indicates error in receiving packet.

    logic [7:0] din_1;
    logic [7:0] din_2;
    logic [7:0] dout_1;
    logic [7:0] dout_2;

    logic [7:0] rnd_value;

    realtime t0,t1,t2;

    uart #(.CLOCK_DIVIDE( 2604 )) uart_1(
        .clk(clk_1),
        .rst(rst_n_1),
        .rx(rx_1),
        .tx(tx_1),
        .transmit(transmit_1),
        .tx_byte(tx_byte_1),
        .received(received_1),
        .rx_byte(rx_byte_1),
        .is_receiving(is_receiving_1),
        .is_transmitting(is_transmitting_1),
        .recv_error(recv_error_1)
    );

    uart #(.CLOCK_DIVIDE( 2604 )) uart_2(
        .clk(clk_2),
        .rst(rst_n_2),
        .rx(rx_2),
        .tx(tx_2),
        .transmit(transmit_2),
        .tx_byte(tx_byte_2),
        .received(received_2),
        .rx_byte(rx_byte_2),
        
        .is_receiving(is_receiving_2),
        .is_transmitting(is_transmitting_2),
        .recv_error(recv_error_2)
    );

    assign rx_1 = tx_2;
    assign rx_2 = tx_1;
    //assign rx_byte_1 = tx_byte_2;
    //assign rx_byte_2 = tx_byte_1;

    //always if ($time <= 6ms) #5ns clk_1 = ~clk_1; else break;
    //always if ($time <= 6ms) #4.99ns clk_2 = ~clk_2; else break;
	 
	 //always #5ns clk_1 = ~clk_2;
	 //always #4.99ns clk_2 = ~clk_2;
	 
	 always #500ms clk_1 = ~clk_2;
	 always #500ms clk_2 = ~clk_2;

    task automatic uart_setup (input [7:0] a, b, ref [7:0] c, d); 
        begin
            clk_1 = 1'b1;
            clk_2 = 1'b1;
            rst_n_1 = 1'b0;
            rst_n_2 = 1'b0;
            transmit_1 = 1'b0;
            transmit_2 = 1'b0;
            c  = a;
            d  = b;
            #100ns;
            rst_n_1 = 1'b1;
            rst_n_2 = 1'b1;
            #100ns;
        end
    endtask

    task automatic new_value (ref clk, transmit, ref [7:0] rnd, tx_byte);
        begin
            @(posedge clk);
            #100ps;
            transmit = 1'b1;

            rnd = $urandom_range(255,0);
            tx_byte = rnd;
            
            @(posedge clk);
            #100ps;
            transmit = 1'b0;
        end
    endtask

    task automatic get_time (ref realtime a, b);
        begin
            a = $realtime;
 
            @(posedge received_1, posedge received_2);
            b = $realtime;
        end
    endtask

    task automatic value_test (input [7:0] a, b);
        begin
            if (a == b) begin
                $display("test pass - value ok");
            end
            else begin
                $display("test failed - value error");
            end
        end
    endtask

    task automatic bit_time_test (input realtime a, b);
        begin
            if ( (103us*10) < (b-a) < (105us*10)) begin  //1 bitidő ~ 104us  //8n1 -> start+adat+stop = 10 bit
                $display("test pass - bit time ok");
            end
            else begin
                $display("test failed - bit time failed");
            end
        end
    endtask

    initial begin
        uart_setup (8'hFA, 8'b1111_1010, tx_byte_1, tx_byte_2);

        repeat (3) begin

            new_value(clk_1, transmit_1, rnd_value, tx_byte_1);

            get_time (t0, t1);

            value_test (rnd_value, rx_byte_2);

            bit_time_test (t0, t1);
            
            #500us;

        end

        #1ms;

        repeat (3) begin

            new_value(clk_2, transmit_2, rnd_value, tx_byte_2);
            
            get_time (t0, t1);

            value_test (rnd_value, rx_byte_1);

            bit_time_test (t0, t1);
            
            #500us;

        end

    end

    /*initial begin //-- V4 --
        clk_1 = 1'b1;
        clk_2 = 1'b1;
        rst_n_1 = 1'b0;
        rst_n_2 = 1'b0;
        transmit_1 = 1'b0;
        transmit_2 = 1'b0;
        tx_byte_1  = 8'hFA;
        tx_byte_2  = 8'b1111_1010;
        #100ns;
        rst_n_1 = 1'b1;
        rst_n_2 = 1'b1;
        #100ns;


        repeat (32) begin

        @(posedge clk_1);
        #100ps;
        transmit_1 = 1'b1;
        rnd_value  = $urandom_range(255,0);
        tx_byte_1  = rnd_value;
        @(posedge clk_1);
        #100ps;
        transmit_1 = 1'b0;

        t0 = $realtime;
 
        @(posedge received_2);
        t1 = $realtime;

        
        if (rnd_value == rx_byte_2) begin
            $display("test pass - value ok");
        end
        else begin
            $display("test failed - value error");
        end


        if ( (103us*10) < (t1-t0) < (105us*10)) begin  //1 bitidő ~ 104us  //8n1 -> start+adat+stop = 10 bit
            $display("test pass - bit time ok");
        end
        else begin
            $display("test failed - bit time failed");
        end

        
        #500us;
        
        end

    end*/


    /*initial begin -- V3 --
        clk_1 = 1'b1;
        clk_2 = 1'b1;
        rst_n_1 = 0;
        rst_n_2 = 0;
        transmit_1 = 0;
        transmit_2 = 0;
        #100ns;
        rst_n_1 = 1;
        rst_n_2 = 1;

        @(posedge clk_1);
        #1ns;
        transmit_1 = 1;
        din_1 = 8'h55;
        tx_byte_1 <= din_1;
        @(posedge clk_1);
        #1ns;
        transmit_1 =   0;

        @(posedge received_2);
        dout_2 = (tx_byte_1 == rx_byte_2);
    end*/


    /*always @(negedge clk_1) begin -- V2 --
        if (!rst_n_1)begin
            din_1 <= 8'h55;
        end
        else if (din_1 > 8'h00 && transmit_1)begin
            din_1 <= din_1 - 8'h01;
        end
        else begin
            din_1 <= din_1;
        end
    end

    always @(posedge clk_1) begin
        if (transmit_1) begin
            dout_1 <= rx_byte_1;
            tx_byte_1 <= din_1;
            rx_byte_2 <= tx_byte_1;
            #1ns
            transmit_1 <= 0;
        end
        else if (!transmit_1) begin
            #1ns
            transmit_1 <= 1;
        end
    end

    always @(posedge clk_2) begin
        if (transmit_2) begin
            dout_2 <= rx_byte_2;
            din_2 <= dout_2;
            tx_byte_2 <= din_2;
            rx_byte_1 <= tx_byte_2;
            #1ns
            transmit_2 <= 0;
        end
        else if (!transmit_2) begin
            #1ns
            transmit_2 <= 1;
        end
    end */


    /*always @(posedge clk_1) begin -- V1 --
        Dout_1 <= rx_byte_1;
        tx_byte_1 <= Din_1;
    end

    always @(posedge clk_2) begin
        Dout_2 <= rx_byte_2;
        tx_byte_2 <= Din_2;
    end*/

endmodule
