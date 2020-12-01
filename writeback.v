module writeback(
    clk,rstd,nextpc,pc
);
    input  clk,rstd;
    input  [31:0]  nextpc;
    output reg [31:0]  pc;

    // reg_file rf_body(
    //     .clk(),
    //     .rstd(),
    //     .wr(),
    //     .ra1(),
    //     .ra2(),
    //     .wa(),
    //     .wren(),
    //     .rr1(),
    //     .rr2()
    // );

    always @(negedge rstd or posedge clk)begin
        if(rstd == 0)   pc <= 32'h000000000;
        else if(clk == 1) begin
             pc <= nextpc;
        end
        else ;
    end

endmodule