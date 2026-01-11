`timescale 1ns/1ps

module uart_tb;

reg clk=0;
reg rst=1;
reg tx_start=0;
reg [7:0] tx_data=0;

wire [7:0] rx_data;
wire rx_done;
wire tx_done;

always #5 clk = ~clk;

uart_top DUT (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .tx_done(tx_done)
);

initial begin
    #100 rst = 0;
    #100;

    tx_data = 8'hA5;
    tx_start = 1;
    #10 tx_start = 0;

    wait(rx_done);

    #1000;
    $stop;
end

endmodule
