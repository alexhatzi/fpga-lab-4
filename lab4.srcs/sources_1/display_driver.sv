
module display_driver 
   # ( parameter PIXELS_PER_ROW    = 640
     , parameter PIXELS_PER_COLUMN = 480
     , parameter A_CLKS            = 3177
     , parameter B_CLKS            = 377
     , parameter C_CLKS            = 189
     , parameter D_CLKS            = 2517
     , parameter E_CLKS            = 94
     , parameter O_CLKS            = 1660000
     , parameter P_CLKS            = 6400
     , parameter Q_CLKS            = 102000
     , parameter R_CLKS            = 1525000
     , parameter S_CLKS            = 35000
     )
     ( input              clk
     , input  logic [3:0] r_color
     , input  logic [3:0] g_color 
     , input  logic [3:0] b_color
     , output logic [3:0] red
     , output logic [3:0] green
     , output logic [3:0] blue
     , output logic       H_SYNC
     , output logic       V_SYNC
     , output logic    rgb_active

     );



    typedef enum logic  [2:0] {HIDLE,HWAIT,HSYNC}   HSYNC_t ; 
    typedef enum logic  [2:0] {VIDLE,VWAIT,VSYNC}   VSYNC_t ; 

    logic [20:0] v_counter ; 
    logic [20:0] h_counter ;  // big enough reg to hold the largest number
    logic [20:0] c_cnt     ; 
    logic [20:0] d_cnt     ;
    logic [20:0] e_cnt     ; 
    HSYNC_t      HSYNC_STATE ; 
    VSYNC_t      VSYNC_STATE ;

    initial v_counter = 0 ; 
    initial c_cnt   = '0  ;
    initial d_cnt   = '0  ; 
    initial e_cnt   = '0  ; 



    // HSYNC state machine 
    always@(posedge clk) begin
      if(V_SYNC) begin
      case (HSYNC_STATE)
            HIDLE:  begin
                       h_counter   <= '0    ; 
                       HSYNC_STATE <= HWAIT ; 
                    end
            HWAIT:  begin
                     if (h_counter == (B_CLKS-1)) begin
                      h_counter   <= '0    ; 
                      HSYNC_STATE <= HSYNC ; 
                     end
                     else h_counter <= h_counter + 1'b1 ; 
                    end
            HSYNC:  begin 
                      if (h_counter == (C_CLKS+D_CLKS+E_CLKS)) begin
                       h_counter   <= '0 ; 
                       H_SYNC      <= '0 ; 
                       HSYNC_STATE <= HWAIT ; 
                      end
                      else begin 
                      h_counter <= h_counter + 1'b1 ; 
                      H_SYNC    <= 1'b1             ; 
                      end
                    end
          default: HSYNC_STATE <= HIDLE ; 
     endcase
     end else begin
      H_SYNC      <= '0    ; 
      h_counter   <= '0    ; 
      HSYNC_STATE <= HWAIT ; 
     end
    end



    // VSYNC state machine 
    always@(posedge clk) begin
        case (VSYNC_STATE) 
             VIDLE: begin
                    v_counter   <= '0    ; 
                    VSYNC_STATE <= VWAIT ; 
                    end
             VWAIT: begin
                     if (v_counter == (P_CLKS-1)) begin
                     v_counter   <= '0    ; 
                     VSYNC_STATE <= VSYNC ; 
                     end
                     else v_counter <= v_counter + 1'b1 ; 
                    end
             VSYNC: begin 
                     if (v_counter == (Q_CLKS+R_CLKS+S_CLKS)) begin
                     v_counter   <= '0    ; 
                     V_SYNC      <= '0    ;
                     VSYNC_STATE <= VWAIT ; 
                     end
                     else begin 
                     v_counter <= v_counter + 1'b1 ; 
                     V_SYNC    <= 1'b1             ; 
                     end
                    end
          default : 
                     VSYNC_STATE <= VIDLE ; 
        endcase
    end


    // RGB Driver
    always@(posedge clk) begin
      if(V_SYNC) begin
        if(H_SYNC) begin  // When HSYNC high
          if (c_cnt == (C_CLKS-1)) begin // Wait for hold time
            if (d_cnt == (D_CLKS-1)) begin // Drive RGB values in active region
                if (e_cnt == (E_CLKS-1)) begin // Stop after D time
                    red    [3:0] <= '0 ;
                    green  [3:0] <= '0 ; 
                    blue   [3:0] <= '0 ; 
                    rgb_active  <= 1'b0;
                end 
                else e_cnt <= e_cnt + 1'b1 ; 
            end
            else begin
            d_cnt       <= d_cnt + 1'b1     ; 
            red   [3:0] <= r_color [3:0]    ; 
            green [3:0] <= g_color [3:0]    ; 
            blue  [3:0] <= b_color [3:0]    ; 
            rgb_active  <= 1'b1             ;
            end
          end 
          else begin
          c_cnt       <= c_cnt + 1'b1 ; 
          end
        end 
        else begin
        c_cnt   <= '0 ; 
        d_cnt   <= '0 ; 
        e_cnt   <= '0 ; 
        end
    end
  end


endmodule
