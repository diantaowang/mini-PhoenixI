module if_id(
    //input 
    clk,
    rst,
    stall,
    if_pc_plus4,
    if_inst,
    //output 
    id_pc_plus4,
    id_inst
);

input clk;
input rst;
input [1:0] stall;
input [31:0] if_pc_plus4;
input [31:0] if_inst;
output reg [31:0] id_pc_plus4;
output reg [31:0] id_inst;

always@(posedge clk or rst) begin
  if(rst == 1'b1) begin
    id_pc_plus4 <= 32'h0;
    id_inst <= 32'h0;
  end
  else if(stall == 2'b10 || stall == 2'b01) begin
    id_pc_plus4 <= 32'h0;
    id_inst <= 32'h0;
  end
  else if(stall == 2'b00) begin
    id_pc_plus4 <= if_pc_plus4;
    id_inst <= if_inst; 
  end 
  else ;
end

endmodule
