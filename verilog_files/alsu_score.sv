package alsu_score_pkg;
import alsu_seq_item_pkg::*;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
`include "uvm_macros.svh"
class alsu_score extends uvm_scoreboard;
`uvm_component_utils(alsu_score)
	uvm_analysis_export #(alsu_seq_item) sb_export;
	uvm_tlm_analysis_fifo #(alsu_seq_item) sb_fifo;
	alsu_seq_item alsu_sequence;
	logic [5:0] out_ref;
	logic [15:0] leds_ref;

	int error_count = 0;
	int correct_count = 0;

	function new(string name = "alsu_score", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);	//must be void here
		super.build_phase(phase);
		sb_export = new("sb_export", this);
		sb_fifo = new("sb_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sb_export.connect(sb_fifo.analysis_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			sb_fifo.get(alsu_sequence);

			if(alsu_sequence.out != alsu_sequence.out_ref || alsu_sequence.leds != alsu_sequence.leds_ref) begin
				`uvm_error("run_phase",
				$sformatf("Comparison failed. Transaction recieved by the DUT:%s while the ref out: 0b%0b and leds ref is 0b%0b",
				alsu_sequence.convert2string(), out_ref, leds_ref));

				error_count++;
			end
			else begin
				`uvm_info("run_phase", $sformatf("Correct ALU out: %s ", alsu_sequence.convert2string()), UVM_HIGH);
				correct_count++;
			end
		end
	endtask

endclass
endpackage
