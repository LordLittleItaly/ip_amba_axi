
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
    output to_app_write_ready,
    output to_app_read_ready,

    output to_app_read_out,

    output to_app_rdata_ready, // RDATA FIFO is ready to be popped
    output to_app_wdata_fulln, // WDATA FIFO is full

    output to_app_read_error, // RRESP Error Propagation form Master
    output to_app_write_error, // BRESP Error Propagation from Master
    
    // From CPU / Application Layer ( Inputs )
    // +++++++++++++++++++++++++++++++++++++++
    // Write Transactions
    // ++++++++++++++++++
    input from_app_sys_resetn,

    input from_app_wdata,
    input from_app_wdata_push,

    input from_app_waddr,
    input from_app_wlen,
    input from_app_wsize,
    input from_app_wtype,

    input from_app_txn_write, // Start the Write Transaction

    // Read Transactions
    // +++++++++++++++++
    input from_app_rdata_pop,

    input from_app_raddr,
    input from_app_rlen,
    input from_app_rsize,
    input from_app_rtype,
    input from_app_txn_read // Start the Read Transaction
);

    // Signals Declarations
    // ++++++++++++++++++++

    // Internal Register Declaration
    // +++++++++++++++++++++++++++++
    reg [3:0] read_oustanding_r, read_oustanding_n;
    reg [3:0] write_outstanding_r, write_outstanding_n;

    reg ip_reset;

    // FSM State Encoding Declaration
    // ++++++++++++++++++++++++++++++
    localparam  [2:0]   IDLE = 'd0,
                        DRIVE_BUS = 'd1,
                        WAIT_VALID = 'd2;

    // State Variables Declaration
    // +++++++++++++++++++++++++++
    reg [2:0] wa_chnl_sr, wa_chnl_sn;
    reg [2:0] wd_chnl_sr, wd_chnl_sn;
    reg [2:0] wr_chnl_sr, wr_chnl_sn;
    reg [2:0] ra_chnl_sr, ra_chnl_sn;
    reg [2:0] rd_chnl_sr, rd_chnl_sn;

    // ++++++++++
    // FSM Design
    // ++++++++++

    assign ip_reset = ip_resetn & from_app_sys_resetn;

    // Write Address Channel
    // +++++++++++++++++++++

    always@( posedge ACLK or negedge ip_resetn )
    begin
        wa_chnl_sr <= wa_chnl_sr;

        if( !ip_resetn )
        begin
            wa_chnl_sr <= IDLE;
        end
        else
        begin
            wa_chnl_sr <= wa_chnl_sn;
        end
    end

    always@( * )
    begin
        wa_chnl_sn = wa_chnl_sr;

        case( wa_chnl_sr )
            IDLE        :   begin
                                if( read_outstanding_r != 15 && from_app_txn_write && to_app_write_ready )
                                begin
                                    wa_chnl_sn = DRIVE_BUS;
                                end
                            end
            DRIVE_BUS   :   begin
                                if( ARREADY )
                                begin
                                    wa_chnl_sn = IDLE;
                                end
                                else if( !ARREADY )
                                begin
                                    wa_chnl_sn = WAIT_VALID;
                                end
                            end
            WAIT_VALID  :   begin
                                if( ARREADY )
                                begin
                                    wa_chnl_sn = IDLE;
                                end
                            end
        endcase
    end

    assign to_app_write_ready = ( ( wa_chnl_sr == IDLE ) && ( read_outstanding_r != 15 ) ) 1'b1 : 1'b0;

    assign AWID = 0;
    assign AWADDR = ( wa_chnl_sr == DRIVE_BUS ) ? from_app_waddr : AWADDR;
    assign AWLEN = ( wa_chnl_sr == DRIVE_BUS ) ? from_app_wlen : AWLEN;
    assign AWSIZE = ( wa_chnl_sr == DRIVE_BUS ) ? from_app_wsize : AWSIZE;
    assign AWBURST = ( wa_chnl_sr == DRIVE_BUS ) ? from_app_wtype : AWBURST;
    assign AWVALID = ( wa_chnl_sr == DRIVE_BUS || wa_chnl_sr == WAIT_VALID ) ? 1'b1 : 1'b0;

    always@( posedge ACLK or negdege ip_resetn )
    begin
        write_outstanding_r <= write_outstanding_r;

        if( ~ip_resetn )
        begin
            write_outstanding_r <= 0;           
        end
        else
        begin
            write_outstanding_r <= write_outstanding_n;
        end
    end

    assign write_outstanding_n = ( wa_chnl_sn == DRIVE_BUS ) ? write_outstanding_r + 1'b1 : write_outstanding_r;

    // Write Data Channel
    // ++++++++++++++++++

    always@( posedge ACLK or negedge ip_resetn )
    begin
        wd_chnl_sr <= wd_chnl_sr;

        if( !ip_resetn )
        begin
            wd_chnl_sr <= IDLE;
        end
        else
        begin
            wd_chnl_sr <= wd_chnl_sn;
        end
    end

    // Write Response Channel 
    // ++++++++++++++++++++++

    always@( posedge ACLK or negedge ip_resetn )
    begin
        wr_chnl_sr <= wr_chnl_sr;

        if( !ip_resetn )
        begin
            wr_chnl_sr <= IDLE;
        end
        else
        begin
            wr_chnl_sr <= wr_chnl_sn;
        end
    end

    // Read Address Channel
    // ++++++++++++++++++++

    always@( posedge ACLK or negedge ip_resetn )
    begin
        ra_chnl_sr <= ra_chnl_sr;

        if( !ip_resetn )
        begin
            ra_chnl_sr <= IDLE;
        end
        else
        begin
            ra_chnl_sr <= ra_chnl_sn;
        end
    end

    // Read Response Channel
    // +++++++++++++++++++++

    always@( posedge ACLK or negedge ip_resetn )
    begin
        rd_chnl_sr <= rd_chnl_sr;

        if( !ip_resetn )
        begin
            rd_chnl_sr <= IDLE;
        end
        else
        begin
            rd_chnl_sr <= rd_chnl_sn;
        end
    end

    // +++++++++++++++++++
    // FIFOs Instantiation
    // +++++++++++++++++++

    // Functions & Tasks, If Any
    // +++++++++++++++++++++++++

endmodule
