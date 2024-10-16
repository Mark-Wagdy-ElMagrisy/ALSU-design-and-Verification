package alsu_env_pkg;
import uvm_pkg::*;
import alsu_agent_pkg::*;
import alsu_score_pkg::*;
import alsu_coverage_pkg::*;
`include "uvm_macros.svh"
class alsu_env extends uvm_env;
	`uvm_component_utils(alsu_env)
 
	alsu_agent agt;
	alsu_score scr;
	alsu_coverage cvr;
 
	function new(string name = "alsu_env", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = alsu_agent::type_id::create("agt", this);
		scr = alsu_score::type_id::create("scr", this);
		cvr = alsu_coverage::type_id::create("cvr", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		agt.agt_port.connect(scr.sb_export);
		agt.agt_port.connect(cvr.cov_export);
	endfunction

endclass
endpackage