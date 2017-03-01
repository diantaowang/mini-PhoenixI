module decode(
    //input 
    pc_plus4,
    inst_i,
    //output
    RegWrite,
    MemtoReg,
    MemWrite,
    ALUControl,
    ALUSrc,
    RegDst,
    Branch,
    Jump,
    reg1_read_o,
    reg2_read_o,
    signed_imm_o,
    Branch_or_Jump_addr_o,
    rs_o,
    rt_o,
    rd_o
);

parameter LW_OP = 6'b100011, BEQ_OP = 6'b000100, EXE_SPECIAL = 6'b000000, 
          SW_OP = 6'b101011, J_OP   = 6'b000010, ADDI_OP     = 6'b001000;
          
parameter ADD_Funct  = 6'b100000, SUB_Funct  = 6'b100010,
          ADDU_Funct = 6'b100001, SUBU_Funct = 6'b100011,
          AND_Funct  = 6'b100100, OR_Funct   = 6'b100101, 
          SLT_Funct  = 6'b101010, SLLV_Funct = 6'b000100,
          SRLV_Funct = 6'b000110;
          
parameter ADD_OP = 4'h1, SUB_OP = 4'h2, ADDU_OP = 4'h3, SUBU_OP = 4'h4,
          AND_OP = 4'h5, OR_OP  = 4'h6, SLT_OP  = 4'h7, SLLV_OP = 4'h8,
          SRLV_OP = 4'h9, NOP_OP = 4'h0;

input [31:0] pc_plus4;
input [31:0] inst_i;
output reg RegWrite;
output reg MemtoReg;
output reg MemWrite;
output reg [3:0] ALUControl;
output reg  ALUSrc;
output reg RegDst;
output reg Branch;
output reg Jump;
output reg reg1_read_o;
output reg reg2_read_o;
output reg [31:0] signed_imm_o;
output reg [31:0] Branch_or_Jump_addr_o;
output [4:0] rs_o;
output [4:0] rt_o;
output [4:0] rd_o;

wire [5:0] Opcode;
wire [5:0] funct;

assign Opcode = inst_i[31:26];
assign funct = inst_i[5:0];
assign rs_o = inst_i[25:21];
assign rt_o = inst_i[20:16];
assign rd_o = inst_i[15:11];

always@(*) begin
  reg1_read_o <= 1'b0;
  reg2_read_o <= 1'b0;
  signed_imm_o <= {{16{inst_i[15]}},inst_i[15:0]};
  Branch_or_Jump_addr_o <= 32'h0;
  case(Opcode)
    EXE_SPECIAL: begin
      {RegWrite,RegDst,ALUSrc,Branch} <= {1'b1, 1'b1, 1'b0, 1'b0};
      {MemWrite,MemtoReg,Jump}        <= {1'b0, 1'b0, 1'b0};
      reg1_read_o <= 1'b1; 
      reg2_read_o <= 1'b1;
      case(funct)
        ADD_Funct:
          ALUControl <= ADD_OP;
        SUB_Funct:
          ALUControl <= SUB_OP;
        ADDU_Funct: 
          ALUControl <= ADDU_OP;
        SUBU_Funct: 
          ALUControl <= SUBU_OP;
        AND_Funct: 
          ALUControl <= AND_OP;
        OR_Funct: 
          ALUControl <= OR_OP;
        SLT_Funct: 
          ALUControl <= SLT_OP;
        SLLV_Funct: 
          ALUControl <= SLLV_OP;
        SRLV_Funct: 
          ALUControl <= SRLV_OP;
        default: begin
          {RegWrite,RegDst,ALUSrc,Branch} <= {1'b0, 1'b0, 1'b0, 1'b0};
          {MemWrite,MemtoReg,ALUControl,Jump}  <= {1'b0, 1'b0, 4'h0, 1'b0};
          reg1_read_o <= 1'b0;
          reg2_read_o <= 1'b0;
        end
      endcase
    end
    LW_OP: begin
      {RegWrite,RegDst,ALUSrc,Branch}     <= {1'b1, 1'b0, 1'b1, 1'b0};
      {MemWrite,MemtoReg,ALUControl,Jump} <= {1'b0, 1'b1, 4'h3, 1'b0};
      reg1_read_o <= 1'b1;
    end
    SW_OP: begin
      {RegWrite,RegDst,ALUSrc,Branch}     <= {1'b0, 1'b0, 1'b1, 1'b0};
      {MemWrite,MemtoReg,ALUControl,Jump} <= {1'b1, 1'b0, 4'h3, 1'b0};
      reg1_read_o <= 1'b1;
      reg2_read_o <= 1'b1;
    end
    BEQ_OP: begin
      {RegWrite,RegDst,ALUSrc,Branch}     <= {1'b0, 1'b0, 1'b0, 1'b1};
      {MemWrite,MemtoReg,ALUControl,Jump} <= {1'b0, 1'b0, 4'h0, 1'b0};
      reg1_read_o <= 1'b1; 
      reg2_read_o <= 1'b1;
      Branch_or_Jump_addr_o <= {signed_imm_o[29:0],2'b00} + pc_plus4;
    end
    J_OP: begin
      {RegWrite,RegDst,ALUSrc,Branch}     <= {1'b0, 1'b0, 1'b0, 1'b0};
      {MemWrite,MemtoReg,ALUControl,Jump} <= {1'b0, 1'b0, 4'h0, 1'b1};
      Branch_or_Jump_addr_o <= {pc_plus4[31:28],inst_i[25:0],2'b00};
    end
    ADDI_OP: begin
      {RegWrite,RegDst,ALUSrc,Branch}     <= {1'b1, 1'b0, 1'b1, 1'b0};
      {MemWrite,MemtoReg,ALUControl,Jump} <= {1'b0, 1'b0, ADD_OP, 1'b0};
      reg1_read_o <= 1'b1;
    end
    default: begin
      {RegWrite,RegDst,ALUSrc,Branch} <= {1'b0, 1'b0, 1'b0, 1'b0};
      {MemWrite,MemtoReg,ALUControl,Jump}  <= {1'b0, 1'b0, 4'h0, 1'b0};
    end
  endcase
end

endmodule
