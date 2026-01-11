module uart_rx (
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output reg  [7:0] rx_data,
    output reg  rx_done
);

    reg [9:0] baud_cnt;
    reg s_tick;

    always @(posedge clk or posedge rst) begin
        if (rst) begin baud_cnt<=0; s_tick<=0; end
        else if (baud_cnt==650) begin baud_cnt<=0; s_tick<=1; end
        else begin baud_cnt<=baud_cnt+1; s_tick<=0; end
    end

    parameter IDLE=2'b00, START=2'b01, DATA=2'b10, STOP=2'b11;

    reg [1:0] state;
    reg [3:0] s_count;
    reg [2:0] n_count;
    reg [7:0] b_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state<=IDLE; s_count<=0; n_count<=0; b_reg<=0;
            rx_done<=0; rx_data<=0;
        end else begin
            rx_done <= 0;

            case(state)

            IDLE:
                if (rx==0) begin s_count<=0; state<=START; end

            START:
                if (s_tick)
                    if (s_count==7) begin
                        if (rx==0) begin s_count<=0; n_count<=0; state<=DATA; end
                        else state<=IDLE;
                    end else s_count<=s_count+1;

            DATA:
                if (s_tick)
                    if (s_count==15) begin
                        s_count<=0;
                        b_reg <= {rx, b_reg[7:1]};
                        if (n_count==7) state<=STOP;
                        else n_count<=n_count+1;
                    end else s_count<=s_count+1;

            STOP:
                if (s_tick)
                    if (s_count==15) begin
                        rx_data<=b_reg;
                        rx_done<=1;
                        state<=IDLE;
                        s_count<=0;
                    end else s_count<=s_count+1;

            endcase
        end
    end
endmodule
