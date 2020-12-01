`include "define.vh"

module cpu(
    clk,
    rstd,
    uart
);

    input clk,rstd,uart; //テストベンチを使わない場合はここをreg型で宣言しないといけない
    wire [31:0]  pc,nextpc;
    wire [31:0]  ir;
    wire [4:0]   srcreg1_num,srcreg2_num,dstreg_num;
    wire [31:0]  imm;
    wire [5:0]   alucode;
    wire [1:0]   aluop1_type,aluop2_type;
    wire reg_we,is_load,is_store,is_halt;
    wire [31:0]  rs1,rs2,mresult;
    wire [31:0] result;
    


    fetch fetch(
        .clk(clk),
        .pc(pc),
        .ir(ir)
    );

    decoder decoder(
        .ir(ir),           // 機械語命令列
        .srcreg1_num(srcreg1_num),
        .srcreg2_num(srcreg2_num),
        .dstreg_num(dstreg_num),
        .imm(imm),
        .alucode(alucode),
        .aluop1_type(aluop1_type),
        .aluop2_type(aluop2_type),
        .reg_we(reg_we),
        .is_load(is_load),
        .is_store(is_store),
        .is_halt(is_halt)
    );

    // reg_file rf_body1(clk,rstd,0,srcreg1_num,srcreg2_num,0, 0,rs1,rs2);

    execution execution(
        .imm(imm),
        .pc(pc),
        .alucode(alucode),
        .aluop1_type(aluop1_type),
        .aluop2_type(aluop2_type),
        // .reg_we(reg_we),
        // .is_load(is_load),
        // .is_store(is_store),
        // .is_halt(is_halt),
        .rs1(rs1),
        .rs2(rs2),
        .nextpc(nextpc),
        .result(result)
    );


    
    mem_access memory(
        .clk(clk),
        .is_load(is_load),
        .is_store(is_store),
        .alucode(alucode),      //alucodeでload,storeのときに読み込むバイト数を判断する符号拡張とかもここで
        .result(result),
        .dstreg_num(dstreg_num),
        .rs2(rs2),
        .mresult(mresult)
    );


    writeback writeback(
        .clk(clk),
        .rstd(rstd),
        .nextpc(nextpc),
        .pc(pc)
    );

    reg_file rf_body(
        .clk(clk),
        .rstd(rstd),
        .wr(is_load ? mresult : result),
        .ra1(srcreg1_num),
        .ra2(srcreg2_num),
        .wa(dstreg_num),
        .wren(reg_we),
        .rr1(rs1),
        .rr2(rs2)
    );

endmodule