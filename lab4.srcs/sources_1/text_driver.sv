

module text_driver (
    input clk
,   input rgb_active
,   output [6:0] addra 
,   input [24:0] douta
,   input  [3:0] digit
,   input        hsync 
,   input        vsync
,   output  logic [3:0] r_color
,   output  logic [3:0] g_color
,   output  logic [3:0] b_color
) ; 

    logic [20:0] clk_cnt     ;

    assign addra = {3'd0,digit[3:0]} ; 

    logic rgb_d ; 
    logic [9:0] active_row_cnt ; 

    always@( posedge clk ) begin
        if (vsync) begin
         rgb_d <= hsync ; 
         if(hsync & !rgb_d) begin // posedge of hsync , increment row counter
            active_row_cnt <= active_row_cnt + 1'b1 ; 
         end 
        end else
        active_row_cnt <= '0 ; 
    end



    always @ (posedge clk) begin

        if(rgb_active) begin
         clk_cnt <= clk_cnt + 1'b1 ;

                if((active_row_cnt >= 21'd36) && (active_row_cnt <= 21'd40)) begin //front porch
                    if ((clk_cnt >= 21'd49) && (clk_cnt <= 21'd55)) begin
                    if (douta[24 - ((active_row_cnt - 21'd36) * 5 + (clk_cnt - 21'd49))]==1'b1) begin
                                r_color <= 4'b1111 ; 
                                g_color <= 4'b1111 ;
                                b_color <= 4'b1111 ; 
                            end
                    end
                    else begin
                            r_color <= 4'b0000 ;
                            g_color <= 4'b1111 ;
                            b_color <= 4'b0000 ; 
                    end
                end
                else begin
                            r_color <= 4'b1111 ;
                            g_color <= 4'b0000 ;
                            b_color <= 4'b0000 ; 
                end
        end else
        clk_cnt <= '0 ; 
    end

initial clk_cnt = '0 ; 
initial active_row_cnt = '0 ; 


logic [25:0] testing ; 
assign testing = 26'd24 - ((active_row_cnt - 21'd132) * 5 + (clk_cnt - 21'd145)) ;

endmodule