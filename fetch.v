`include "define.vh"

module fetch(
    clk,
    pc,
    ir
);
    input clk;
    input [31:0] pc;
    output [31:0] ir;
//    wire [4:0] pc_addr;
    wire [31:0] ins;
    
//    assign pc_addr = pc[4:0];

    rom rom(clk,pc,ins);
    assign ir = ins;
endmodule