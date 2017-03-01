module mini_MIPS_top(
    clk,
    rst
);

input clk;
input rst;

// Global variable
wire [5:0] stall;

// pc_reg && rom_1Kx32
wire [31:0] pc;
wire [31:0] pc_plus4;
wire ce;
// pc_reg && id
wire branch_flag;
wire [31:0] branch_addr;

// if_id && rom_1Kx32
wire [31:0] rom_inst;
// if_id && id
wire [31:0] InstD;
wire [31:0] PcPlus4D;

// id && data conflict
wire [31:0] rd1_from_regfiles;
wire [31:0] rd2_from_regfiles;
wire [31:0] reg_dat_from_wb;
// id && ctrl
wire [1:0]  red1_select_signal;
wire [1:0]  red2_select_signal;
wire reg1_read;
wire reg2_read;
// id && id_ex
wire RegWriteD;
wire MemtoRegD;
wire MemWriteD;
wire [3:0] ALUControlD;
wire ALUSrcD;
wire RegDstD;
wire [31:0] reg1_dat;
wire [31:0] reg2_dat;
wire [31:0] SignImmD;
wire [4:0] rsD;
wire [4:0] rtD;
wire [4:0] rdD;

// id_ex && ex
wire RegWrite_o;
wire [3:0] ALUControl_o;
wire ALUSrc_o;
wire RegDst_o;
wire [31:0] reg1_dat_ex_i;
wire [31:0] reg2_dat_ex_i;
wire [31:0] SignImmE;
wire [4:0] rsE;
wire [4:0] rtE;
wire [4:0] rdE;
// id_ex && ex_mem
wire MemWrite_o;
wire MemtoReg_o;

// ex && ex_mem
wire RegWriteE_o;
wire [31:0] ALUDataE_o;
wire [31:0] WriteDataE_o;
wire [4:0]  WriteRegE_o;

// ex_mem && mem
wire RegWriteM_i;
wire MemtoRegM_i;
wire MemWriteM_i;
wire [31:0] ALUDataM_i;
wire [31:0] WriteDataM_i;
wire [4:0]  WriteRegM_i;

// mem && ram4Kx32
wire ram_we;
wire [31:0] ram_addr;
wire [31:0] ram_wd;
wire [31:0] ram_rd;
// mem && wb
wire RegWriteM_o;
wire [31:0] WriteRegDataM_o;
wire [4:0]  WriteRegAddrM_o;

// mem_wb && regfiles
wire RegWriteW_o;
wire [4:0] WriteRegAddrW_o;

pc_reg pc_reg_inst(
    //input
    .clk(clk),
    .rst(rst),
    .stall(stall[0]),
    .branch_flag_i(branch_flag),
    .branch_addr_i(branch_addr),
    //output 
    .pc(pc),
    .pc_plus4(pc_plus4),
    .ce(ce)
);

rom_1Kx32 rom_1Kx32_inst(
    //input
    .ce(ce),
    .addr(pc),
    //output
    .rd(rom_inst)
);

if_id if_id_inst(
    //input 
    .clk(clk),
    .rst(rst),
    .stall(stall[2:1]),
    .if_pc_plus4(pc_plus4),
    .if_inst(rom_inst),
    //output 
    .id_pc_plus4(PcPlus4D),
    .id_inst(InstD)
);

id id_inst(
    //input 
    .pc_plus4(PcPlus4D),
    .inst_i(InstD),
    //input reg1
    .reg1_dat_from_regfile(rd1_from_regfiles),
    .reg1_dat_from_ex(ALUDataE_o),
    .reg1_dat_from_mem(WriteRegDataM_o),
    .reg1_dat_from_wb(reg_dat_from_wb),
    .red1_select_signal(red1_select_signal),
    //input reg2
    .reg2_dat_from_regfile(rd2_from_regfiles),
    .reg2_dat_from_ex(ALUDataE_o),
    .reg2_dat_from_mem(WriteRegDataM_o),
    .reg2_dat_from_wb(reg_dat_from_wb),
    .red2_select_signal(red2_select_signal),
    //output
    .RegWrite(RegWriteD),
    .MemtoReg(MemtoRegD),
    .MemWrite(MemWriteD),
    .ALUControl(ALUControlD),
    .ALUSrc(ALUSrcD),
    .RegDst(RegDstD),
    .reg1_dat(reg1_dat),
    .reg2_dat(reg2_dat),
    .reg1_read_o(reg1_read),
    .reg2_read_o(reg2_read),
    .signed_imm_o(SignImmD),
    .Branch_or_Jump(branch_flag),
    .Branch_or_Jump_addr_o(branch_addr),
    .rs_o(rsD),
    .rt_o(rtD),
    .rd_o(rdD) 
);

regfile regfile_inst(
    //input 
    .clk(clk),
    .we(RegWriteW_o),
    .addr0(InstD[25:21]),
    .addr1(InstD[20:16]),
    .addr2(WriteRegAddrW_o),
    .wd(reg_dat_from_wb),
    //output
    .rd1(rd1_from_regfiles),
    .rd2(rd2_from_regfiles)
);

id_ex id_ex_inst(
    //input 
    .clk(clk),
    .rst(rst),
    .stall(stall[3:2]),
    .RegWrite_i(RegWriteD),
    .MemtoReg_i(MemtoRegD),
    .MemWrite_i(MemWriteD),
    .ALUControl_i(ALUControlD),
    .ALUSrc_i(ALUSrcD),
    .RegDst_i(RegDstD),
    .reg1_dat_i(reg1_dat),
    .reg2_dat_i(reg2_dat),
    .signed_imm_i(SignImmD),
    .rs_i(rsD),
    .rt_i(rtD),
    .rd_i(rdD),
    //output
    .RegWrite_o(RegWrite_o),
    .MemtoReg_o(MemtoReg_o),
    .MemWrite_o(MemWrite_o),
    .ALUControl_o(ALUControl_o),
    .ALUSrc_o(ALUSrc_o),
    .RegDst_o(RegDst_o),
    .reg1_dat_o(reg1_dat_ex_i),
    .reg2_dat_o(reg2_dat_ex_i),
    .signed_imm_o(SignImmE),
    .rs_o(rsE),
    .rt_o(rtE),
    .rd_o(rdE)
);

ex ex_inst(
    //input 
    .RegWriteD(RegWrite_o),
    .F(ALUControl_o),
    .ALUSrcD(ALUSrc_o),
    .RegDstD(RegDst_o),
    .reg1_dat_i(reg1_dat_ex_i),
    .reg2_dat_i(reg2_dat_ex_i),
    .signed_imm_i(SignImmE),
    .rs_i(rsE),
    .rt_i(rtE),
    .rd_i(rdE),
    //output
    .RegWriteE(RegWriteE_o),
    .ALUData_o(ALUDataE_o),
    .WriteDataE(WriteDataE_o),
    .WriteRegE(WriteRegE_o)
);

ex_mem ex_mem_inst(
    //input 
    .clk(clk),
    .rst(rst),
    .stall(stall[4:3]),
    .RegWriteE_i(RegWriteE_o),
    .MemtoRegE_i(MemtoReg_o),
    .MemWriteE_i(MemWrite_o),
    .ALUDataE_i(ALUDataE_o),
    .WriteDataE_i(WriteDataE_o),
    .WriteRegE_i(WriteRegE_o),
    //output
    .RegWriteM(RegWriteM_i),
    .MemtoRegM(MemtoRegM_i),
    .MemWriteM(MemWriteM_i),
    .ALUDataM(ALUDataM_i),
    .WriteDataM(WriteDataM_i),
    .WriteRegM(WriteRegM_i)
);

mem mem_inst(
    //input 
    .RegWriteM(RegWriteM_i),
    .MemtoRegM(MemtoRegM_i),
    .MemWriteM(MemWriteM_i),
    .ALUDataM(ALUDataM_i),
    .WriteDataM(WriteDataM_i),
    .WriteRegM(WriteRegM_i),
    .mem_data_i(ram_rd),
    //output 
    .RegWriteM_o(RegWriteM_o),
    .WriteRegData(WriteRegDataM_o),
    .WriteRegAddr(WriteRegAddrM_o),
    .mem_addr(ram_addr),
    .mem_we(ram_we),
    .mem_wd(ram_wd)
);

ram_4Kx32 ram_4Kx32_inst(
    //input    
    .clk(clk),
    .rst(rst),      
    .we(ram_we),      
    .addr(ram_addr),    
    .wd(ram_wd),      
    //output
    .rd(ram_rd)       
);

mem_wb mem_wb_inst(
    //input 
    .clk(clk),
    .rst(rst),
    .stall(stall[5:4]),
    .RegWriteW_i(RegWriteM_o),
    .WriteRegData_i(WriteRegDataM_o),
    .WriteRegAddr_i(WriteRegAddrM_o),
    //output
    .RegWriteW_o(RegWriteW_o),
    .WriteRegData_o(reg_dat_from_wb),
    .WriteRegAddr_o(WriteRegAddrW_o)
);

ctrl ctrl_inst(
    //input
    .rst(rst), 
    .reg1_read(reg1_read),
    .reg2_read(reg2_read),
    .reg1_read_addr(rsD),
    .reg2_read_addr(rtD),
    .ex_reg_write(RegWriteE_o),
    .ex_reg_write_addr(WriteRegE_o),
    .mem_reg_write(RegWriteM_o),
    .mem_reg_write_addr(WriteRegAddrM_o),
    .wb_reg_write(RegWriteW_o),
    .wb_reg_write_addr(WriteRegAddrW_o),
    .ex_MemtoReg(MemtoReg_o),
    //output
    .reg1_select(red1_select_signal),
    .reg2_select(red2_select_signal),
    .stall(stall)
);

endmodule
