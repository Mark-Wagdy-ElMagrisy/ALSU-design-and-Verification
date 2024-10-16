package alsu_agent_pkg;
import uvm_pkg::*;
import alsu_sequencer_pkg::*;
import alsu_driver_pkg::*;
import alsu_monitor_pkg::*;
import alsu_seq_item_pkg::*;
`include "uvm_macros.svh"

class alsu_agent extends uvm_agent;
`uvm_component_utils(alsu_agent)

	virtual alsu_if alsu_agent_vif;
	alsu_sequencer sqr;
	alsu_driver drv;
	alsu_monitor mon;
	uvm_analysis_port #(alsu_seq_item) agt_port;

	function new(string name = "alsu_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual alsu_if)::get(this, "", "VIF", alsu_agent_vif))
		`uvm_fatal("build_phase", "unable to get configuration object")
		sqr=alsu_sequencer::type_id::create("sqr", this);
		drv=alsu_driver::type_id::create("drv", this);
		mon=alsu_monitor::type_id::create("mon", this);
		agt_port = new("agt_port", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.alsu_driver_vif = alsu_agent_vif;
		mon.alsu_monitor_vif = alsu_agent_vif;
		drv.seq_item_port.connect(sqr.seq_item_export);
		mon.mon_port.connect(agt_port);
	endfunction
endclass
endpackage