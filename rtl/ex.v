module ex(
    //input 
    RegWriteD,
    F,
    ALUSrcD,
    RegDstD,
    reg1_dat_i,
    reg2_dat_i,
    signed_imm_i,
    rs_i,
    rt_i,
    rd_i,
    //output
    RegWriteE,
    ALUData_o,
    WriteDataE,
    WriteRegE
);

parameter ADD_OP = 4'h1, SUB_OP = 4'h2, ADDU_OP = 4'h3, SUBU_OP = 4'h4,
          AND_OP = 4'h5, OR_OP  = 4'h6, SLT_OP  = 4'h7, SLLV_OP = 4'h8,
          SRLV_OP = 4'h9, NOP_OP = 4'h0;

//input 
input RegWriteD;
input [3:0] F;
input ALUSrcD;
input RegDstD;
input [31:0] reg1_dat_i;
input [31:0] reg2_dat_i;
input [31:0] signed_imm_i;
input [4:0] rs_i;
input [4:0] rt_i;
input [4:0] rd_i;
//output
output reg RegWriteE;
output reg [31:0] ALUData_o;
output [31:0] WriteDataE;
output [4:0] WriteRegE;

wire [31:0] SrcA;
wire [31:0] SrcB;
wire [31:0] SrcB_mux;
wire [31:0] sum_tmp;
wire ov_sum;
wire srcA_lt_srcB;

assign SrcA = reg1_dat_i;

assign SrcB = (ALUSrcD == 1'b0) ? reg2_dat_i : signed_imm_i;

assign SrcB_mux = ((F == SUB_OP) || (F == SUBU_OP) || (F == SLT_OP)) ? 
                  (~SrcB + 32'b1) : SrcB;
                  
assign sum_tmp = SrcA + SrcB_mux;

assign ov_sum = (SrcA[31] && SrcB_mux[31] && !sum_tmp[31]) ||
                (!SrcA[31] && !SrcB_mux[31] && sum_tmp[31]);

assign srcA_lt_srcB = (SrcA[31] && !SrcB[31]) || 
                      (SrcA[31] && SrcB[31] && sum_tmp[31]) ||
                      (!SrcA[31] && !SrcB[31] && sum_tmp[31]);

assign WriteDataE = reg2_dat_i;
assign WriteRegE = (RegDstD == 1'b0) ? rt_i : rd_i;

always@(*) begin
  RegWriteE <= RegWriteD;
  case(F)
    AND_OP: begin
      ALUData_o <= SrcA & SrcB;
    end
    OR_OP: begin
      ALUData_o <= SrcA | SrcB;
    end
    ADD_OP,SUB_OP: begin
      ALUData_o <= sum_tmp;
      RegWriteE <= RegWriteD && (!ov_sum);
    end
    ADDU_OP,SUBU_OP: begin
      ALUData_o <= sum_tmp;
    end
    NOP_OP: begin           //take case
      ALUData_o <= 32'h0;
    end
    SLLV_OP: begin
      ALUData_o <= SrcB << SrcA[4:0];
    end
    SRLV_OP: begin
      ALUData_o <= SrcB >> SrcA[4:0];
    end
    SLT_OP: begin
      ALUData_o <= srcA_lt_srcB;
    end
  endcase
end

endmodule
