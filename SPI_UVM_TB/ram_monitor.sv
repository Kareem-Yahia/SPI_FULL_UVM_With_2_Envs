package ram_monitor;
	import uvm_pkg::*;
	import ram_seq_item::*;
`include "uvm_macros.svh";
class ram_monitor extends uvm_monitor;
	`uvm_component_utils(ram_monitor)
virtual ram_if ram_vif;
ram_seq_item rsp_seq_item;
uvm_analysis_port #(ram_seq_item) mon_ap;

    function new(string name="ram_monitor", uvm_component parent=null);
      super.new(name, parent);
    endfunction: new
    function void build_phase (uvm_phase phase);
    	super.build_phase(phase);
    	mon_ap=new("mon_ap",this);
    endfunction  
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		rsp_seq_item=ram_seq_item::type_id::create("rsp_seq_item");
		@(negedge ram_vif.clk);

		rsp_seq_item.rst_n=ram_vif.rst_n;
		rsp_seq_item.din=ram_vif.din;
		rsp_seq_item.rx_valid=ram_vif.rx_valid;
		rsp_seq_item.tx_valid=ram_vif.tx_valid;
		rsp_seq_item.dout=ram_vif.dout;
		//for golden model
		rsp_seq_item.dout_ex=ram_vif.dout_ex;
		rsp_seq_item.tx_valid_ex=ram_vif.tx_valid_ex;

		mon_ap.write(rsp_seq_item);
		`uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH)


	end
endtask : run_phase
endclass

endpackage : ram_monitor