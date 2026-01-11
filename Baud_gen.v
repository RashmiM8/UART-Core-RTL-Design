module baud_gen( 
    input wire clk,
    input wire rst,
    output reg baud_tick
);
    parameter clk_freq = 100000000;
    parameter baud_rate = 9600;
    parameter DIVISOR = clk_freq/baud_rate;
    
    reg[13:0] count; //enough to count till 10417
    
    always@(posedge clk or posedge rst )begin
        if(rst)begin
          count<=0;
          baud_tick<=0;
        end
        else begin 
        if(count == DIVISOR-1)begin 
          count<=0;
          baud_tick<=1; //generate pulse
        end
        else begin 
          count <= count+1;
          baud_tick<=0;
        end
      end 
    end
endmodule
        
        
    
    