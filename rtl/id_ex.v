module id_ex(
    //input 
    input clk,
    input rst,
    input [1:0] stall,
    input RegWrite_i,
    input MemtoReg_i,
    input MemWrite_i,
    input [3:0] ALUControl_i,
    input ALUSrc_i,
    input RegDst_i,
    input [31:0] reg1_dat_i,
    input [31:0] reg2_dat_i,
    input [31:0] signed_imm_i,
    input [4:0] rs_i,
    input [4:0] rt_i,
    input [4:0] rd_i,
    //output
    output reg RegWrite_o,
    output reg MemtoReg_o,
    output reg MemWrite_o,
    output reg [3:0] ALUControl_o,
    output reg ALUSrc_o,
    output reg RegDst_o,
    output reg [31:0] reg1_dat_o,
    output reg [31:0] reg2_dat_o,
    output reg [31:0] signed_imm_o,
    output reg [4:0] rs_o,
    output reg [4:0] rt_o,
    output reg [4:0] rd_o
);

always@(posedge clk or rst) begin
  if(rst == 1'b1) begin
    {RegWrite_o,MemtoReg_o,MemWrite_o} <= 3'b0;
    {ALUControl_o,ALUSrc_o,RegDst_o} <= 3'b0;
    reg1_dat_o <= 32'h0; 
    reg2_dat_o <= 32'h0;
    signed_imm_o <= 32'h0;
    rs_o <= 5'b00000;
    rt_o <= 5'b00000;
    rd_o <= 5'b00000;
  end
  else if(stall == 2'b10 || stall == 2'b01) begin
    {RegWrite_o,MemtoReg_o,MemWrite_o} <= 3'b0;
    {ALUControl_o,ALUSrc_o,RegDst_o} <= 3'b0;
    reg1_dat_o <= 32'h0; 
    reg2_dat_o <= 32'h0;
    signed_imm_o <= 32'h0;
    rs_o <= 5'b00000;
    rt_o <= 5'b00000;
    rd_o <= 5'b00000;
  end
  else if(stall == 2'b00) begin
    {RegWrite_o,MemtoReg_o,MemWrite_o} <= {RegWrite_i,MemtoReg_i,MemWrite_i};
    {ALUControl_o,ALUSrc_o,RegDst_o}   <= {ALUControl_i,ALUSrc_i,RegDst_i};
    reg1_dat_o <= reg1_dat_i; 
    reg2_dat_o <= reg2_dat_i;
    signed_imm_o <= signed_imm_i;
    rs_o <= rs_i;
    rt_o <= rt_i;
    rd_o <= rd_i;
  end
  else ;
end

endmodule
