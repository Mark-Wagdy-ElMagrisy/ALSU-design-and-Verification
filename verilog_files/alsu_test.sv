package alsu_test_pkg;
import uvm_pkg::*;
import alsu_env_pkg::*;
import alsu_seq_pkg::*;
`include "uvm_macros.svh"
  
class alsu_test extends uvm_test;
	`uvm_component_utils(alsu_test)

	alsu_env env;
	virtual alsu_if alsu_test_vif;
	alsu_seq main_seq;

	function new(string name = "alsu_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = alsu_env::type_id::create("env",this);
		main_seq = alsu_seq::type_id::create("main_seq");

		uvm_config_db #(virtual alsu_if)::get(this, "", "ALSU_IF", alsu_test_vif);

		uvm_config_db #(virtual alsu_if)::set(this, "*", "VIF", alsu_test_vif);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		//#100000;
		main_seq.start(env.agt.sqr);
		`uvm_info("run_phase","Inside the ALSU test",UVM_NONE)
		phase.drop_objection(this);
	endtask

endclass
endpackage