module ctrl_buff(
    input logic clk,en,rst,
    input logic reg_wr, wr_en, rd_en, 
    input logic [1:0] wb_sel,
    output logic reg_wrMW, wr_enMW, rd_enMW, 
    output logic [1:0] wb_selMW
);
    always_ff @( posedge clk or posedge rst ) begin 
        if (rst) begin
            reg_wrMW <= 0;
            wr_enMW  <= 0;
            rd_enMW  <= 0;
            wb_selMW <= 0;
        end

        else if (en) begin
            reg_wrMW <= reg_wr;
            wr_enMW  <= wr_en;
            rd_enMW  <= rd_en;
            wb_selMW <= wb_sel;
        end
        else begin
            reg_wrMW <= reg_wrMW;
            wr_enMW  <= wr_enMW ;
            rd_enMW  <= rd_enMW ;
            wb_selMW <= wb_selMW;
        end
    end
    
endmodule