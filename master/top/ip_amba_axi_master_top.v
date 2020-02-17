
`include "ip_amba_axi_top_defines.vh"
`include "ip_amba_axi_top_parameters.vh"

module ip_amba_axi_master_top `IP_AMBA_AXI_PARAM_DECL (  

    // AHB Interface Side Signals
    // Global Inputs
    // ++++++++++++++++++++++++++
    input ACLK,
    input ARESETn,
    
    // Master Inputs
    // +++++++++++++
    input AWREADY,

    input WREADY,

    input BRESP,
    //input BUSER,
    input BVALID,

    input ARREADY,

    input RID,
    input RDATA,
    input RRESP,
    input RLAST,
    //input RUSER,
    input RVALID,
    
    // Master Outpucs
    // ++++++++++++++
    output AWID,
    output AWADDR,
    output AWLEN,
    output AWSIZE,
    output AWBURST,
    //output AWLOCK,
    //output AWCACHE,
    //output AWPROT,
    //output AWQOS,
    //output AWREGION,
    //output AWUSER,
    output AWVALID,

    output WDATA,
    output WSTRB,
    output WLAST,
    //output WUSER,
    output WVALID,

    output BREADY,

    output ARID,
    output ARADDR,
    output ARLEN,
    output ARSIZE,
    output ARBURST,
    //output ARLOCK,
    //output ARCACHE,
    //output ARPROT,
    //output ARQOS,
    //output ARREGION,
    //output ARUSER,
    output ARVALID,

    output RREADY,
    
    // CPU / Application Layer's End's Control Signals
    // To CPU / Application Layer ( Outputs )
    // +++++++++++++++++++++++++++++++++++++++++++++++
    output from_app_txn_write_ready,
    output from_app_txn_read_ready,

    output from_app_read_out,
    output from_app_read_addr_out,

    output from_app_read_error,
    output from_app_write_error,
    
    // From CPU / Application Layer ( Inputs )
    // +++++++++++++++++++++++++++++++++++++++
    output to_app_waddr,
    output to_app_wdata,
    output to_app_blen,
    output to_app_bsize,
    output to_app_btype,
    output to_app_txn_write,
    
    output to_app_txn_read


);

endmodule
