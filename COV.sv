class dram_cov #(type T=dram_seq_item) extends uvm_subscriber #(T);
`uvm_component_utils(dram_cov)
T pkt;
   real cov;
covergroup cg;	
  address : coverpoint pkt.add {
    bins b1[]    = {[0:63]};
   // bins b2    = {[36:]};
  }
  data : coverpoint  pkt.data_in {
    bins b3    = {[0:150]};
    bins b4    = {[151:255]};
  }
  wr : coverpoint pkt.wr;
  en : coverpoint pkt.en;
endgroup

function new (string name = "dram_cov", uvm_component parent);
      super.new (name, parent);
	  cg = new;
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction
	  
virtual function void write (T t);
	`uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);
	pkt = t;
	cg.sample();
  $display("coverage=%f", cg.get_inst_coverage);
endfunction
      function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=cg.get_coverage();
  endfunction
  
   function void report_phase(uvm_phase phase);
    super.report_phase(phase);
     `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM);
  endfunction

endclass