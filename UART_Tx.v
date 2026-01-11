module uart_tx (
    input  wire clk,
    input  wire rst,
    input  wire baud_tick,
    input  wire tx_start,
    input  wire [7:0] tx_data,
    output reg  tx,
    output reg  tx_done
);

    parameter IDLE=2'b00, START=2'b01, DATA=2'b10, STOP=2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1;
            tx_done <= 0;
            bit_count <= 0;
        end else begin
            tx_done <= 0;

            if (baud_tick) begin
                case(state)

                IDLE: begin
                    tx <= 1;
                    if (tx_start) begin
                        shift_reg <= tx_data;
                        state <= START;
                    end
                end

                START: begin
                    tx <= 0;
                    bit_count <= 0;
                    state <= DATA;
                end

                DATA: begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    if (bit_count == 7) state <= STOP;
                    else bit_count <= bit_count + 1;
                end

                STOP: begin
                    tx <= 1;
                    tx_done <= 1;
                    state <= IDLE;
                end

                endcase
            end
        end
    end
endmodule
