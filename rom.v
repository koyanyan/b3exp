module rom(clk, r_addr, r_data); 
    

    input clk;
    input  [31:0] r_addr;
    output [31:0] r_data;
//    reg [31:0] addr_reg;
    reg [31:0] mem [0:25000];
    
//    initial $readmemh("/home/denjo/exp/b3exp/benchmarks/tests/ControlTransfer/code.hex", mem);
//    initial $readmemh("/home/denjo/exp/b3exp/benchmarks/tests/IntRegImm/code.hex", mem);
//    initial $readmemh("/home/denjo/exp/b3exp/benchmarks/tests/IntRegReg/code.hex", mem);
//    initial $readmemh("/home/denjo/exp/b3exp/benchmarks/tests/Uart/code.hex", mem);
    initial $readmemh("/home/denjo/exp/b3exp/benchmarks/Coremark_for_Synthesis/code.hex", mem);


//    always @(posedge clk) begin
//        addr_reg <= r_addr;           //読み出しアドレスを同期
//    end
    assign r_data = mem[r_addr >> 2];
endmodule