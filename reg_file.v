module reg_file(clk,rstd,wr,ra1,ra2,wa,wren,rr1,rr2);
input   clk,rstd,wren;
input   [31:0]  wr;
input   [4:0]   ra1,ra2,wa;
output  [31:0]  rr1,rr2;

reg     [31:0]  regfield[0:31];

assign rr1 = regfield[ra1];
assign rr2 = regfield[ra2];

initial begin
    for (integer i = 0; i < 32; i = i + 1) regfield[i] <= 32'h0;
end

always @(negedge rstd or posedge clk)begin
    if(rstd == 0)   regfield[0] <= 32'h00000000;
    else if (wren == 1 && wa != 5'd0) regfield[wa] <= wr;    //零レジスタは必ず0だから書き込むのはアドレスが0でないときのみ
end

endmodule

//読み出し  reg_file rf_body(clk,rstd,0,     rs1,rs2,0, 0,op1,op2);
//書き出し　reg_file rf_body(clk,rstd,result,0,  0,  wa,1,0,  0);
//reg_file rf_body(clk,rstd,書き込む値,読み込む番地1,読み込み番地2,書き込む番地,write_enable,読み込んだ値1,読み込んだ値2);