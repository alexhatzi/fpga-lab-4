//////////////////////////////////////////////////////////////////////////////////
// Company: UCF EEL5722C with Dr. Lin
// Engineer: Alexander Hatzilias
// 
// Create Date: 09/01/2024 02:09:29 PM
// Design Name: Basys 3 Keyboard Input Driver 
// Module Name: ps2input
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


module ps2input( 
     input clk   
    ,input kbd_clk
    ,input kbd_data
    ,output logic [7:0] key // 8 bit keyboard input (partiy bit stripped)
    ,output logic dvld      // If parity bit matches, dvld is high
    ,output logic [1:0] error_detect
    ,output logic [2:0] state_detect 
    ,output logic [3:0] bit_loc
    );

    logic [8:0] kbd_buffer ; 
    logic       kbd_clk_d  ;       // KBD CLK Delay (used to capture negative edge)

    typedef enum  {IDLE,ACTIVE,STOP} kbd_state_t ;   
    kbd_state_t KBD_STATE ; 


initial begin
KBD_STATE = IDLE  ; 
end


    always@(negedge clk)                
        kbd_clk_d <= kbd_clk ; 

        always @(negedge kbd_clk) begin
            case (KBD_STATE)
                IDLE: begin 
                    state_detect <= 3'b001; 
                    dvld         <= 1'b0;  
                    error_detect <= 2'b00; 
                    if (kbd_data == 1'b0 && kbd_clk_d == 1'b1) begin  // Check both kbd_data and previous kbd_clk
                    KBD_STATE <= ACTIVE;  
                    end
                end

                ACTIVE: begin
                    state_detect <= 3'b010 ; 
                    if (bit_loc < 4'd9) begin
                        kbd_buffer[bit_loc] <= kbd_data;  
                        bit_loc <= bit_loc + 1'b1      ; 
                    end
                    else  
                    if (!(^kbd_buffer[7:0] == kbd_buffer[8])) begin 
                        key  [7:0]       <= kbd_buffer [7:0] ; 
                        kbd_buffer       <= 9'b0    ;    
                        dvld             <= 1'b1    ;  
                        KBD_STATE        <= IDLE    ;  // Transition back to IDLE
                        bit_loc          <= 4'b0000 ;  // Reset bit_loc
                    end else 
                        error_detect     <= 2'b01   ;
                end
            endcase
        end

endmodule
