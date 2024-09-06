

module text_driver (
    input clk
,   input rgb_active
,   output [6:0] addra 
,   input [24:0] douta
,   input  [3:0] digit
,   input [9:0] row_cnt 
,   output  logic [3:0] r_color
,   output  logic [3:0] g_color
,   output  logic [3:0] b_color
) ; 

    logic [20:0] clk_cnt     ;

    assign addra = {3'd0,digit} ; 

    

    always @ (posedge clk) begin
        if(rgb_active) begin
         clk_cnt <= clk_cnt + 1'b1 ;
        case (clk_cnt)
        21'd0 , 21'd1 , 21'd2 , 21'd3 , 21'd4 , 21'd5 : begin 
                case (row_cnt)
        21'd0 , 21'd1 , 21'd2 , 21'd3 , 21'd4 , 21'd5 : begin
                        r_color <= (douta[row_cnt]==1'b1) ? 4'b1111 : 4'b0000 ; 
                        g_color <= (douta[row_cnt]==1'b1) ? 4'b1111 : 4'b0000 ; 
                        b_color <= (douta[row_cnt]==1'b1) ? 4'b1111 : 4'b0000 ; 

                end

                default : begin
                        r_color <= 4'b0000 ;
                        g_color <= 4'b0000 ;
                        b_color <= 4'b0000 ; 
                end
                endcase 
             end
        endcase
        end
        clk_cnt <= '0 ; 
    end


endmodule