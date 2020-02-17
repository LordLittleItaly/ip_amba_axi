// *******************************************************
// Date Created   : 18 January, 2020
// Author         : :P
// *******************************************************

// Declaration Parameters
// ----------------------
`define IP_AMBA_AXI_PARAM_DECL          #(  parameter RID_WIDTH = `RID_WIDTH, \
                                            parameter RDATA_WIDTH = `RDATA_WIDTH, \
                                            \
                                            parameter RRESP_WIDTH = `RRESP_WIDTH, \
                                            \
                                            parameter AWID_WIDTH = `AWID_WIDTH, \
                                            parameter AWADDR_WIDTH = `AWADDR_WIDTH, \
                                            parameter AWLEN_WIDTH = `AWLEN_WIDTH, \
                                            parameter AWSIZE_WIDTH = `AWSIZE_WIDTH, \
                                            parameter AWBURST_WIDTH = `AWBURST_WIDTH, \
                                            \
                                            parameter WDATA_WIDTH = `WDATA_WIDTH, \
                                            parameter WSTRB_WIDTH = `WSTRB_WIDTH, \
                                            \
                                            parameter ARID_WIDTH = `ARID_WIDTH, \
                                            parameter ARADDR_WIDTH = `ARADDR_WIDTH, \
                                            parameter ARLEN_WIDTH = `ARLEN_WIDTH, \
                                            parameter ARSIZE_WIDTH = `ARSIZE_WIDTH, \
                                            parameter ARBURST_WIDTH = `ARBURST_WIDTH, \
                                            \
                                            parameter READ_DATA_WIDTH = `READ_DATA_WIDTH, \
                                            parameter WRITE_DATA_WIDTH = `WRITE_DATA_WIDTH, \
                                            parameter ADDR_WIDTH = `ADDR_WIDTH, \
                                            parameter BLEN_WIDTH = `BLEN_WIDTH, \
                                            parameter BSIZE_WIDTH = `BSIZE_WIDTH, \
                                            parameter BTYPE_WIDTH = `BTYPE_WIDTH \
                                        )
