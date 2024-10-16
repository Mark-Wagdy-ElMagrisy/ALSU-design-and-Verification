package alsu_seq_item_pkg;
import enum_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class alsu_seq_item extends uvm_sequence_item;
`uvm_object_utils(alsu_seq_item)

	parameter MAXPOS = 3;
	parameter MAXNEG = -4;

	logic clk;
	rand logic rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
	rand logic [2:0] opcode;
	rand logic signed [2:0] A, B;
	logic [15:0] leds, leds_ref;
	logic signed [5:0] out, out_ref;

	function new(string name = "alsu_seq_item");
		super.new(name);
	endfunction


	function string convert2string();
		return $sformatf("%s convert2string called", super.convert2string());
	endfunction

	function string convert2string_stimulus();
		return $sformatf("convert2string_stimulus called");
	endfunction
	
	//constraints
	constraint reseter {rst dist {0:=95, 1:=5};}
	constraint add_mult {if(opcode == ADD || opcode == MULT) {
				A dist {0:=30, MAXPOS:=30, MAXNEG:=30, [-3:2]:=5};
				B dist {0:=30, MAXPOS:=30, MAXNEG:=30, [-3:2]:=5};
				}}
	constraint A_high {if((opcode == OR || opcode == XOR) && red_op_A) {
				A dist {1:=40, 2:=30, -4:=30};
				B dist {0:=100};
				}}
	constraint B_high {if((opcode == OR || opcode == XOR) && red_op_B && !red_op_A) { //to avoid overlapping constraints
				B dist {1:=40, 2:=30, -4:=30};
				A dist {0:=100};
				}}
	constraint invalid {opcode dist {INVALID_6:=3, INVALID_7:=3, [OR:ROTATE]:=94};
				//additional code to get more valid outputs
				if(opcode != OR || opcode != XOR) {
					red_op_A dist {1:=5, 0:=95};
					red_op_B dist {1:=5, 0:=95};}}

	constraint less_bypass {bypass_A dist {1:=30, 0:=70};
						bypass_B dist {1:=30, 0:=70};}


endclass
endpackage