`timescale 1ns/1ps

module miniMIPS_top_tb;

reg clk_50M;
reg rst;

initial begin
	 clk_50M <= 1'b0;
	 forever #10 clk_50M <= ~clk_50M;
end

initial begin
	rst = 1'b1;
	#55 rst = 1'b0;
	#5000
		$stop;
end

mini_MIPS_top mini_MIPS_top0(
    .clk(clk_50M),
    .rst(rst)
);

`ifdef DUMP_FSDB
initial begin
	$fsdbDumpfile("test.fsdb");
	$fsdbDumpvars;
end
`endif	

endmodule

