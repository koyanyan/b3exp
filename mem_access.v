`include "define.vh"

module mem_access(
    clk,
    is_load,
    is_store,
    alucode,    //alucodeでload,storeのときに読み込むバイト数を判断する符号拡張とかもここで
    result,
    dstreg_num,
    rs2,
    mresult
);
    input  clk;
    input  is_load,is_store;
    input  [31:0] result,rs2;
    input  [5:0]  alucode;
    input [4:0] dstreg_num;
    output reg [31:0]  mresult;

    reg [4:0] r_addr,w_addr;
    reg [3:0] we,re;
    reg [31:0] w_data;
    wire [31:0] r_data;

    ram ram(
        .clk(clk),
        .we(we),
        .re(re),
        .r_addr(r_addr),
        .r_data(r_data),
        .w_addr(w_addr),
        .w_data(w_data)
    );

always @(*)begin
    if(is_load == `ENABLE)begin     //rd番地にメモリアドレスのresult番地の値を書き込む
        case(alucode)
            `ALU_LB:begin
                re <= 4'b0001;
                r_addr <= result;
                mresult <= r_data;
            end
            `ALU_LH:begin
                re <= 4'b0011;
                r_addr <= result;
                mresult <= r_data;
            end
            `ALU_LW:begin
                re <= 4'b1111;
                r_addr <= result;                
                mresult <= r_data;
            end
            `ALU_LBU:begin
                re <= 4'b0001;
                r_addr <= result;
                mresult <= {{24{1'b0}},r_data[7:0]};
            end
            `ALU_LHU:begin
                re <= 4'b0011;
                r_addr <= result;
                mresult <= {{16{1'b0}},r_data[15:0]};
            end
            default: ;
        endcase
    end
    else ;
end
always @(posedge clk)begin
    if(is_store == `ENABLE)begin    //メモリアドレスのresult番地にrs2の値を書き込む
        case(alucode)
            `ALU_SB:begin
                 we <= 4'b0001;
                 w_addr <= result;
                 w_data <= rs2;
            end
            `ALU_SH:begin
                we <= 4'b0011;
                 w_addr <= result;
                 w_data <= rs2;
            end
            `ALU_SW:begin
                we <= 4'b1111;
                 w_addr <= result;
                 w_data <= rs2;
            end
            default: ;
        endcase
    end
    else ;
end
endmodule