module uart_top (
    input  wire clk,
    input  wire rst,
    input  wire tx_start,
    input  wire [7:0] tx_data,
    output wire [7:0] rx_data,
    output wire rx_done,
    output wire tx_done
);

    wire tx_wire;
    wire s_tick;
    reg [3:0] div16;
    reg baud_tick;

    reg [9:0] baud_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin baud_cnt<=0; end
        else if (baud_cnt==650) baud_cnt<=0;
        else baud_cnt<=baud_cnt+1;
    end

    assign s_tick = (baud_cnt==650);

    always @(posedge clk or posedge rst) begin
        if (rst) begin div16<=0; baud_tick<=0; end
        else if (s_tick)
            if (div16==15) begin div16<=0; baud_tick<=1; end
            else begin div16<=div16+1; baud_tick<=0; end
        else baud_tick<=0;
    end

    uart_tx TX (
        .clk(clk), .rst(rst),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx_wire),
        .tx_done(tx_done)
    );

    uart_rx RX (
        .clk(clk), .rst(rst),
        .rx(tx_wire),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule
