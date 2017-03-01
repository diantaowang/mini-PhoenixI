module ex_mem(
    //input 
    clk,
    rst,
    stall,
    RegWriteE_i,
    MemtoRegE_i,
    MemWriteE_i,
    ALUDataE_i,
    WriteDataE_i,
    WriteRegE_i,
    //output
    RegWriteM,
    MemtoRegM,
    MemWriteM,
    ALUDataM,
    WriteDataM,
    WriteRegM
);

//input 
input clk;
input rst;
input [1:0] stall;
input RegWriteE_i;
input MemtoRegE_i;
input MemWriteE_i;
input [31:0] ALUDataE_i;
input [31:0] WriteDataE_i;
input [4:0] WriteRegE_i;
//output
output reg RegWriteM;
output reg MemtoRegM;
output reg MemWriteM;
output reg [31:0] ALUDataM;
output reg [31:0]WriteDataM;
output reg [4:0]WriteRegM;

always@(posedge clk or rst) begin
  if(rst == 1'b1) begin
    RegWriteM <= 1'b0;
    MemtoRegM <= 1'b0;
    MemWriteM <= 1'b0;
    ALUDataM <= 32'h0;
    WriteDataM <= 32'h0;
    WriteRegM <= 5'b00000;
  end
  else if(stall == 2'b10 || stall == 2'b01) begin
    RegWriteM <= 1'b0;
    MemtoRegM <= 1'b0;
    MemWriteM <= 1'b0;
    ALUDataM <= 32'h0;
    WriteDataM <= 32'h0;
    WriteRegM <= 5'b00000;
  end
  else if(stall == 2'b00) begin
    RegWriteM <= RegWriteE_i;
    MemtoRegM <= MemtoRegE_i;
    MemWriteM <= MemWriteE_i;
    ALUDataM <= ALUDataE_i;
    WriteDataM <= WriteDataE_i;
    WriteRegM <= WriteRegE_i;
  end
  else ;
end

endmodule
