import uvm_pkg::*;
import alsu_test_pkg::*;
`include "uvm_macros.svh"
 
module top();
	bit clk;

	initial begin
		forever
		#1 clk = ~clk;
	end

	alsu_if alsuif(clk);
	ALSU DUT(alsuif);
	golden_ALSU REF(alsuif);
	bind ALSU SVA SVA_inst(alsuif);

	initial begin
		uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "ALSU_IF", alsuif);
		run_test("alsu_test"); //the name of the class
	end
endmodule
