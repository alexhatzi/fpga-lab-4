


module lab4_top 
        ( input clk
        , input KBD_CLK
        , input KBD_DATA
        , output logic debugBUT_LED
        , output logic debugDISP_LED
        , output logic [3:0] red
        , output logic [3:0] green
        , output logic [3:0] blue
        , output logic hsync
        , output logic vsync
) ; 


   


        logic rgb_active ; 
        logic [9:0] row_cnt ; 
        logic dvld ; 
        logic [7:0] key ;
        logic [1:0] error_detect ; 
        logic [2:0] state_detect ; 
        logic [3:0] bit_loc     ;
        logic [3:0] digit       ;

        logic [3:0] r_color ; 
        logic [3:0] g_color ; 
        logic [3:0] b_color ; 

        logic clka ; 
        logic [6:0] addra ; 
        logic [24:0] douta ; 

        always @ (posedge KBD_CLK) begin
        debugBUT_LED <=  ~debugBUT_LED ;
        end 

        always@ (posedge clk) begin
        if(rgb_active)
        debugDISP_LED <= ~debugDISP_LED ; 
         end

        initial begin
                debugBUT_LED = 0 ; 
                debugDISP_LED = 0 ;
        end

        display_driver u_disp_driv 
                (       .clk            (clk)
                ,       .r_color        (r_color)
                ,       .g_color        (g_color)
                ,       .b_color        (b_color)
                ,       .red            (red)
                ,       .blue           (green)
                ,       .green          (blue)
                ,       .H_SYNC         (hsync)
                ,       .V_SYNC         (vsync)
                ,       .rgb_active     (rgb_active)
                ,       .h_counter      (row_cnt)
                ) ;




        ps2input u_ps2_inp
                (       .clk            (clk)
                ,       .kbd_clk        (KBD_CLK)
                ,       .kbd_data       (KBD_DATA)
                ,       .key            (key)
                ,       .dvld           (dvld)
                ,       .error_detect   (error_detect)
                ,       .state_detect   (state_detect)
                ,       .bit_loc        (bit_loc)
                ) ; 


        ps2decoder u_ps2_dec
                (       .clk            (clk)
                ,       .key            (key)
                ,       .dvld           (dvld)
                ,       .digit          (digit)
                ) ; 


        text_driver u_text_driver
                (       .clk            (clk)
                ,       .rgb_active     (rgb_active)
                ,       .addra          (addra)
                ,       .douta          (douta)
                ,       .digit          (digit)
                ,       .row_cnt        (row_cnt)
                ,       .r_color        (r_color)
                ,       .g_color        (g_color)
                ,       .b_color        (b_color)
                ) ; 


                assign clka = clk ; 


        blk_mem_gen_0 u_bram
                (       .addra           (addra)
                ,       .douta           (douta)
                ,       .clka            (clka)
                ) ; 


        // ila_0 u_ila (
        //         .clk (clk)
        // ,       .probe0 (clka)
        // ,       .probe1 (KBD_CLK)
        // ,       .probe2 (KBD_DATA)
        // ,       .probe3 (debugBUT_LED)
        // ,       .probe4 (debugDISP_LED)
        // ,       .probe5 (red)
        // ,       .probe6 (green)
        // ,       .probe7 (blue)
        // ,       .probe8 (hsync)
        // ,       .probe9 (vsync)
        // ) ; 

endmodule






















 




