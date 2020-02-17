
// Bus Widths Definition
// +++++++++++++++++++++

`define RID_WIDTH                       4
`define RDATA_WIDTH                     32

`define RRESP_WIDTH                     3

`define AWID_WIDTH                      4
`define AWADDR_WIDTH                    32
`define AWLEN_WIDTH                     8
`define AWSIZE_WIDTH                    3
`define AWBURST_WIDTH                   2

`define WDATA_WIDTH                     32
`define WSTRB_WIDTH                     ( $clog2(32) )

`define ARID_WIDTH                      4
`define ARADDR_WIDTH                    32
`define ARLEN_WIDTH                     8
`define ARSIZE_WIDTH                    3
`define ARBURST_WIDTH                   2

// Application Layer Bus Definition
// ++++++++++++++++++++++++++++++++

`define READ_DATA_WIDTH                 32
`define WRITE_DATA_WIDTH                32
`define ADDR_WIDTH                      32
`define BLEN_WIDTH                      8
`define BSIZE_WIDTH                     3
`define BTYPE_WIDTH                     2
