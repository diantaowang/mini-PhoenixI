module ctrl(
    //input
    rst, 
    reg1_read,
    reg2_read,
    reg1_read_addr,
    reg2_read_addr,
    ex_reg_write,
    ex_reg_write_addr,
    mem_reg_write,
    mem_reg_write_addr,
    wb_reg_write,
    wb_reg_write_addr,
    ex_MemtoReg,
    //output
    reg1_select,
    reg2_select,
    stall
);
 
//input
input rst;
input reg1_read;
input reg2_read;
input [4:0] reg1_read_addr;
input [4:0] reg2_read_addr;
input ex_reg_write;
input [4:0] ex_reg_write_addr;
input mem_reg_write;
input [4:0] mem_reg_write_addr;
input wb_reg_write;
input [4:0] wb_reg_write_addr;
input ex_MemtoReg;
//output
output reg [1:0] reg1_select;
output reg [1:0] reg2_select;
output reg  [5:0] stall;

always@(*) begin
  if(rst == 1'b1)
    reg1_select <= 2'b00;
  else if(reg1_read == 1'b1 && ex_reg_write == 1'b1 && (reg1_read_addr == ex_reg_write_addr))
    reg1_select <= 2'b01;
  else if(reg1_read == 1'b1 && mem_reg_write == 1'b1 && (reg1_read_addr == mem_reg_write_addr))
    reg1_select <= 2'b10;
  else if(reg1_read == 1'b1 && wb_reg_write == 1'b1 && (reg1_read_addr == wb_reg_write_addr))
    reg1_select <= 2'b11;
  else
    reg1_select <= 2'b00; 
end

always@(*) begin
  if(rst == 1'b1)
    reg2_select <= 2'b00;
  else if(reg2_read == 1'b1 && ex_reg_write == 1'b1 && (reg2_read_addr == ex_reg_write_addr))
    reg2_select <= 2'b01;
  else if(reg2_read == 1'b1 && mem_reg_write == 1'b1 && (reg2_read_addr == mem_reg_write_addr))
    reg2_select <= 2'b10; 
  else if(reg2_read == 1'b1 && wb_reg_write == 1'b1 && (reg2_read_addr == wb_reg_write_addr))
    reg2_select <= 2'b11;
  else
    reg2_select <= 2'b00; 
end

always@(*) begin
  if(rst == 1'b1)
    stall <= 6'b000000;
  else if(reg1_read == 1'b1 && ex_MemtoReg == 1'b1 && (reg1_read_addr == ex_reg_write_addr))
    stall <= 6'b000111;
  else if(reg2_read == 1'b1 && ex_MemtoReg == 1'b1 && (reg2_read_addr == ex_reg_write_addr))
    stall <= 6'b000111;
  else 
    stall <= 6'b000000;
end

endmodule

