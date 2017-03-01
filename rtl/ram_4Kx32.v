module ram_4Kx32(
    //input    
    clk,
    rst,      
    we,      
    addr,    
    wd,      
    //output
    rd       
);
                  
input clk;
input rst;
input we;
input [31:0] addr;
input [31:0] wd;
output reg [31:0] rd;

reg [31:0] mem[4095:0];

always@(posedge clk) begin
  if(we) 
    mem[addr[13:2]] <= wd;
  else ;
end

always@(*) begin
	if(rst == 1'b1)
		rd <= 32'h0;
	else
	  rd <= mem[addr[13:2]];
end

endmodule



	  
			 
	  
