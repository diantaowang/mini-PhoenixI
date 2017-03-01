module regfile(
    //input 
    clk,
    we,
    addr0,
    addr1,
    addr2,
    wd,
    //output
    rd1,
    rd2
);
       
input clk;
input we;
input  [4:0] addr0;
input  [4:0] addr1;
input  [4:0] addr2;
input  [31:0] wd;
output reg [31:0] rd1;
output reg [31:0] rd2;
 
reg [31:0] regs[31:0];

always@(*) begin
  rd1 <= (addr0 == 5'b0) ? 5'b0 : regs[addr0];
  rd2 <= (addr1 == 5'b0) ? 5'b0 : regs[addr1];
end

always@(posedge clk) begin
  if(we)
    regs[addr2] <= (addr2 != 5'b0) ? wd : 32'h0;
  else ;  
end

endmodule

  
  
    
