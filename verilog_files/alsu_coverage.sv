package alsu_coverage_pkg;
import alsu_seq_item_pkg::*;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
import enum_pkg::*;
`include "uvm_macros.svh"
class alsu_coverage extends uvm_component;
	`uvm_component_utils(alsu_coverage)
	uvm_analysis_export #(alsu_seq_item) cov_export;
	uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo;
	alsu_seq_item seq_item_cov;

	//covergroup
	covergroup cvr_gp;
		A_cp: coverpoint seq_item_cov.A {
			bins A_data_0 = {0};
			bins A_data_max = {seq_item_cov.MAXPOS};
			bins A_data_min = {seq_item_cov.MAXNEG};
			bins A_data_default = default;}

		red_op_A_cp: coverpoint seq_item_cov.A iff (seq_item_cov.red_op_A) {
			bins A_data_walkinggones[] = {'b001, 'b010, 'b100};}

		B_cp: coverpoint seq_item_cov.B{
			bins B_data_0 = {0};
			bins B_data_max = {seq_item_cov.MAXPOS};
			bins B_data_min = {seq_item_cov.MAXNEG};
			bins B_data_default = default;}

		red_op_Bcp: coverpoint seq_item_cov.B iff (seq_item_cov.red_op_B) {
			bins B_data_walkinggones[] = {'b001, 'b010, 'b100};}

		ALU_cp: coverpoint seq_item_cov.opcode {
			bins Bins_shift[] = {SHIFT, ROTATE};
			bins Bins_arith[] = {ADD, MULT};
			bins Bins_bitwise[]= {OR, XOR};
			illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
			bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);}

		Acover: coverpoint seq_item_cov.A{option.weight=0;}
		Bcover: coverpoint seq_item_cov.B{option.weight=0;}
		cincover: coverpoint seq_item_cov.cin{option.weight=0;}
		serial_incover: coverpoint seq_item_cov.serial_in{option.weight=0;}
		directioncover: coverpoint seq_item_cov.direction{option.weight=0;}
		red_op_Acover: coverpoint seq_item_cov.red_op_A{option.weight=0;}
		red_op_Bcover: coverpoint seq_item_cov.red_op_B{option.weight=0;}


		add_mult: cross ALU_cp, A_cp, B_cp {
		option.cross_auto_bin_max=0;
			bins add = binsof(ALU_cp) intersect {ADD} && binsof(A_cp) && binsof(B_cp);
			bins mult = binsof(ALU_cp) intersect {MULT} && binsof(A_cp) && binsof(B_cp);}

		c_in: cross ALU_cp, cincover {
		option.cross_auto_bin_max=0;
			bins cin_add = binsof(cincover) && binsof(ALU_cp) intersect {ADD};}

		shifting: cross ALU_cp, serial_incover {
		option.cross_auto_bin_max=0;
			bins serial_shift = binsof(serial_incover) && binsof(ALU_cp) intersect {SHIFT};}

		direction_cov: cross ALU_cp, directioncover {
		option.cross_auto_bin_max=0;
			bins direct_shift = binsof(directioncover) && binsof(ALU_cp) intersect {SHIFT};
			bins direct_rot = binsof(directioncover) && binsof(ALU_cp) intersect {SHIFT};}

		op_A: cross ALU_cp, red_op_Acover, Acover, Bcover, red_op_Bcover  {
		option.cross_auto_bin_max=0;
			ignore_bins B_1 = op_A with ( red_op_Bcover != 0);
			ignore_bins op_A_0 = op_A with (!red_op_Acover);
			bins A_op1 = binsof(ALU_cp) intersect {OR} && binsof(Acover) intersect {1};
			bins A_op2 = binsof(ALU_cp) intersect {OR} && binsof(Acover) intersect {2};
			bins A_op4 = binsof(ALU_cp) intersect {OR} && binsof(Acover) intersect {4};}

		op_B: cross ALU_cp, red_op_Bcover, Acover, Bcover, red_op_Acover {
		option.cross_auto_bin_max=0;
			ignore_bins A_1 = op_B with ( red_op_Acover != 0);
			ignore_bins op_B_0 = op_B with (!red_op_Bcover);
			bins B_op1 = binsof(ALU_cp) intersect {OR} && binsof(Bcover) intersect {1};
			bins B_op2 = binsof(ALU_cp) intersect {OR} && binsof(Bcover) intersect {2};
			bins B_op4 = binsof(ALU_cp) intersect {OR} && binsof(Bcover) intersect {4};}

		invalid_red: cross ALU_cp, red_op_Acover, red_op_Bcover {
		option.cross_auto_bin_max=0;
			illegal_bins invalidA = binsof(ALU_cp) intersect {ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} 
				&& binsof(red_op_Acover) intersect {1};
			illegal_bins invalidB = binsof(ALU_cp) intersect {ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} 
				&& binsof(red_op_Bcover) intersect {1};}
	endgroup


	function new(string name = "alsu_coverage", uvm_component parent = null);
		super.new(name,parent);
		cvr_gp = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cov_export = new("cov_export", this);
		cov_fifo = new("cov_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cov_export.connect(cov_fifo.analysis_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			cov_fifo.get(seq_item_cov);
			cvr_gp.sample();
		end
	endtask
endclass
endpackage
