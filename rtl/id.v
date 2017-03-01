module id(
    //input 
    pc_plus4,
    inst_i,
    //input reg1
    reg1_dat_from_regfile,
    reg1_dat_from_ex,
    reg1_dat_from_mem,
    reg1_dat_from_wb,
    red1_select_signal,
    //input reg2
    reg2_dat_from_regfile,
    reg2_dat_from_ex,
    reg2_dat_from_mem,
    reg2_dat_from_wb,
    red2_select_signal,
    //output
    RegWrite,
    MemtoReg,
    MemWrite,
    ALUControl,
    ALUSrc,
    RegDst,
    reg1_dat,
    reg2_dat,
    reg1_read_o,
    reg2_read_o,
    signed_imm_o,
    Branch_or_Jump,
    Branch_or_Jump_addr_o,
    rs_o,
    rt_o,
    rd_o 
);

input [31:0] pc_plus4;
input [31:0] inst_i;
//input reg1
input [31:0] reg1_dat_from_regfile;
input [31:0] reg1_dat_from_ex;
input [31:0] reg1_dat_from_mem;
input [31:0] reg1_dat_from_wb;
input [1:0]  red1_select_signal;
//input reg2
input [31:0] reg2_dat_from_regfile;
input [31:0] reg2_dat_from_ex;
input [31:0] reg2_dat_from_mem;
input [31:0] reg2_dat_from_wb;
input [1:0]  red2_select_signal;
//output 
output RegWrite;
output MemtoReg;
output MemWrite;
output [3:0] ALUControl;
output ALUSrc;
output RegDst;
output [31:0] reg1_dat;
output [31:0] reg2_dat;
output reg1_read_o;
output reg2_read_o;
output [31:0] signed_imm_o;
output Branch_or_Jump;
output [31:0] Branch_or_Jump_addr_o;
output [4:0] rs_o;
output [4:0] rt_o;
output [4:0] rd_o;

wire branch;
wire jump;

decode decode_inst(
    //input 
    .pc_plus4(pc_plus4),
    .inst_i(inst_i),
    //output
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .Branch(branch),
    .Jump(jump),
    .reg1_read_o(reg1_read_o),
    .reg2_read_o(reg2_read_o),
    .signed_imm_o(signed_imm_o),
    .Branch_or_Jump_addr_o(Branch_or_Jump_addr_o),
    .rs_o(rs_o),
    .rt_o(rt_o),
    .rd_o(rd_o)
);

mult4_1 mult4_1_inst(
    //input reg1
    .reg1_dat_from_regfile(reg1_dat_from_regfile),
    .reg1_dat_from_ex(reg1_dat_from_ex),
    .reg1_dat_from_mem(reg1_dat_from_mem),
    .reg1_dat_from_wb(reg1_dat_from_wb),
    .red1_select_signal(red1_select_signal),
    //input reg2
    .reg2_dat_from_regfile(reg2_dat_from_regfile),
    .reg2_dat_from_ex(reg2_dat_from_ex),
    .reg2_dat_from_mem(reg2_dat_from_mem),
    .reg2_dat_from_wb(reg2_dat_from_wb),
    .red2_select_signal(red2_select_signal),
    //input 
    .Branch(branch),
    .Jump(jump),
    //output
    .reg1_dat(reg1_dat),
    .reg2_dat(reg2_dat),
    .Branch_or_Jump(Branch_or_Jump)
);

endmodule
