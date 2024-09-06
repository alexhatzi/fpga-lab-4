//////////////////////////////////////////////////////////////////////////////////
// Company: UCF EEL5722C with Dr. Lin
// Engineer: Alexander Hatzilias
// 
// Create Date: 09/01/2024 02:09:29 PM
// Design Name: Basys 3 Keyboard Input Driver 
// Module Name: ps2decoder
// Project Name: 
// Target Devices: Digilent Basys 3 (Artix 7) 
// Tool Versions: Vivado 2024
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ps2decoder (
    input  clk
   ,input  logic [7:0]  key
   ,input dvld
   ,output logic [3:0] digit
);



    always@(posedge clk) begin
  if(dvld) begin
            case (key)
              8'h16   : digit = 4'd1   ;
              8'h1E   : digit = 4'd2   ; 
              8'h26   : digit = 4'd3   ;
              8'h25   : digit = 4'd4   ; 
              8'h2E   : digit = 4'd5   ; 
              8'h36   : digit = 4'd6   ;
              8'h3D   : digit = 4'd7   ; 
              8'h3E   : digit = 4'd8   ;
              8'h46   : digit = 4'd9   ;     
              8'h45   : digit = 4'd0   ;
              8'hff   : digit = 4'd10  ; 
            default   : digit = 4'd15  ;     // Used to trigger decoder condition to indicate error
            endcase
        end
    end




initial digit = '0 ; 


endmodule 