module pc_reg(
    //input
    clk,
    rst,
    stall,
    branch_flag_i,
    branch_addr_i,
    //output 
    pc,
    pc_plus4,
    ce
);

input clk;
input rst;
input stall;
input branch_flag_i;
input [31:0] branch_addr_i;

output reg [31:0] pc;
output [31:0] pc_plus4;
output reg ce;

assign pc_plus4 = pc + 32'h4;

always@(posedge clk) begin
  if(rst == 1'b1)
    ce <= 1'b0;
  else
    ce <= 1'b1;
end

always@(posedge clk) begin
  if(ce <= 1'b0)
    pc <= 32'h0;
  else if(stall == 1'b1)
    pc <= pc;
  else if(branch_flag_i == 1'b1)
    pc <= branch_addr_i;
  else
    pc <= pc_plus4;
end

endmodule


    

