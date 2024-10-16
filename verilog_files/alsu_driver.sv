package alsu_driver_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
`include "uvm_macros.svh"
class alsu_driver extends uvm_driver #(alsu_seq_item);
	`uvm_component_utils(alsu_driver)
 
	virtual alsu_if alsu_driver_vif;
	alsu_seq_item seq_item;

	function new(string name = "alsu_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item=alsu_seq_item::type_id::create("seq_item");
			seq_item_port.get_next_item(seq_item);

			alsu_driver_vif.rst = seq_item.rst;
			alsu_driver_vif.cin = seq_item.cin;
			alsu_driver_vif.red_op_A = seq_item.red_op_A;
			alsu_driver_vif.red_op_B = seq_item.red_op_B;
			alsu_driver_vif.bypass_A = seq_item.bypass_A;
			alsu_driver_vif.bypass_B = seq_item.bypass_B;
			alsu_driver_vif.direction = seq_item.direction;
			alsu_driver_vif.serial_in = seq_item.serial_in;
			alsu_driver_vif.opcode = seq_item.opcode;
			alsu_driver_vif.A = seq_item.A;
			alsu_driver_vif.B = seq_item.B;
			@(negedge alsu_driver_vif.clk);

			seq_item_port.item_done();
		end
		`uvm_info("run_phase","Inside the ALSU test",UVM_NONE)

	/*
		alsu_driver_vif.rst = 1;
		alsu_driver_vif.cin = 0;
		alsu_driver_vif.red_op_A = 0;
		alsu_driver_vif.red_op_B = 0;
		alsu_driver_vif.bypass_A = 0;
		alsu_driver_vif.bypass_B = 0;
		alsu_driver_vif.direction = 0;
		alsu_driver_vif.serial_in = 0;
		alsu_driver_vif.opcode = 0;
		alsu_driver_vif.A = 0;
		alsu_driver_vif.B = 0;
		@(negedge alsu_driver_vif.clk);
		@(negedge alsu_driver_vif.clk);
		alsu_driver_vif.rst = 0;
		forever begin
			alsu_driver_vif.cin = $random;
			alsu_driver_vif.red_op_A = $random;
			alsu_driver_vif.red_op_B = $random;
			alsu_driver_vif.bypass_A = $random;
			alsu_driver_vif.bypass_B = $random;
			alsu_driver_vif.direction = $random;
			alsu_driver_vif.serial_in = $random;
			alsu_driver_vif.opcode = $random;
			alsu_driver_vif.A = $random;
			alsu_driver_vif.B = $random;
			@(negedge alsu_driver_vif.clk);
		end
	*/
	endtask
endclass
endpackage
