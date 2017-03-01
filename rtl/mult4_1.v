module mult4_1(
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
    //input 
    Branch,
    Jump,
    //output
    reg1_dat,
    reg2_dat,
    Branch_or_Jump
);

//input reg1
input [31:0] reg1_dat_from_regfile;
input [31:0] reg1_dat_from_ex;
input [31:0] reg1_dat_from_mem;
input [31:0] reg1_dat_from_wb;
input [1:0] red1_select_signal;
//input reg2
input [31:0] reg2_dat_from_regfile;
input [31:0] reg2_dat_from_ex;
input [31:0] reg2_dat_from_mem;
input [31:0] reg2_dat_from_wb;
input [1:0] red2_select_signal;
//input  
input Branch;
input Jump;
//output
output reg [31:0] reg1_dat;
output reg [31:0] reg2_dat;
output Branch_or_Jump;

assign Branch_or_Jump = ((reg1_dat == reg2_dat) && Branch) || Jump;

always@(*) begin
  case(red1_select_signal)
    2'b00:
      reg1_dat <= reg1_dat_from_regfile;
    2'b01:
      reg1_dat <= reg1_dat_from_ex;
    2'b10:
      reg1_dat <= reg1_dat_from_mem;
    2'b11:
      reg1_dat <= reg1_dat_from_wb;
  endcase   
end

always@(*) begin
  case(red2_select_signal)
    2'b00:
      reg2_dat <= reg2_dat_from_regfile;
    2'b01:
      reg2_dat <= reg2_dat_from_ex;
    2'b10:
      reg2_dat <= reg2_dat_from_mem;
    2'b11:
      reg2_dat <= reg2_dat_from_wb;
  endcase   
end

endmodule