package alsu_seq_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
`include "uvm_macros.svh"

class alsu_seq extends uvm_sequence #(alsu_seq_item);
`uvm_object_utils(alsu_seq)
alsu_seq_item main_seq;

	function new(string name = "alsu_seq_item");
		super.new(name);
	endfunction

	task body;
		main_seq = alsu_seq_item::type_id::create("main_seq");
		start_item(main_seq);

		main_seq.rst=1;
		main_seq.cin=0;
		main_seq.red_op_A=0;
		main_seq.red_op_B=0;
		main_seq.bypass_A=0;
		main_seq.bypass_B=0;
		main_seq.direction=0;
		main_seq.serial_in=0;
		main_seq.opcode=0;
		main_seq.A=0;
		main_seq.B=0;

		finish_item(main_seq);

	repeat(5000) begin
		main_seq = alsu_seq_item::type_id::create("main_seq");
		start_item(main_seq);
		assert(main_seq.randomize());
		finish_item(main_seq);
	end

	repeat(2) begin
		main_seq = alsu_seq_item::type_id::create("main_seq");
		start_item(main_seq);
		//assert(main_seq.randomize());
		main_seq.bypass_A=0;
		main_seq.bypass_B=0;
		main_seq.red_op_A=1;
		main_seq.red_op_B=1;
		main_seq.opcode=0;
		finish_item(main_seq);
	end	

	repeat(2) begin
		main_seq = alsu_seq_item::type_id::create("main_seq");
		start_item(main_seq);
		//assert(main_seq.randomize());
		main_seq.bypass_A=0;
		main_seq.bypass_B=0;
		main_seq.red_op_A=1;
		main_seq.red_op_B=0;
		main_seq.opcode=0;
		finish_item(main_seq);
	end

	repeat(2) begin
		main_seq = alsu_seq_item::type_id::create("main_seq");
		start_item(main_seq);
		//assert(main_seq.randomize());
		main_seq.bypass_A=0;
		main_seq.bypass_B=0;
		main_seq.red_op_A=1;
		main_seq.red_op_B=1;
		main_seq.opcode=1;
		finish_item(main_seq);
	end
	endtask
endclass
endpackage
