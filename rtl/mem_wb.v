module mem_wb(
    //input 
    clk,
    rst,
    stall,
    RegWriteW_i,
    WriteRegData_i,
    WriteRegAddr_i,
    //output
    RegWriteW_o,
    WriteRegData_o,
    WriteRegAddr_o
);

//input 
input clk;
input rst;
input [1:0] stall;
input RegWriteW_i;
input [31:0] WriteRegData_i;
input [4:0] WriteRegAddr_i;
//output
output reg RegWriteW_o;
output reg [31:0] WriteRegData_o;
output reg [4:0] WriteRegAddr_o;

always@(posedge clk or rst) begin
  if(rst == 1'b1) begin
    RegWriteW_o <= 1'b0;
    WriteRegData_o <= 32'h0;
    WriteRegAddr_o <= 5'b00000;
  end 
  else if(stall == 2'b10 || stall == 2'b01) begin
    RegWriteW_o <= 1'b0;
    WriteRegData_o <= 32'h0;
    WriteRegAddr_o <= 5'b00000;
  end
  else if(stall == 2'b00) begin
    RegWriteW_o <= RegWriteW_i;
    WriteRegData_o <= WriteRegData_i;
    WriteRegAddr_o <= WriteRegAddr_i;
  end
  else ;  
end

endmodule


