`include "define.vh"

module alu(
    alucode,       // 演算種別
    op1,          // 入力データ1
    op2,          // 入力データ2
    alu_result,   // 演算結果
    br_taken             // 分岐の有無
);
    input  [5:0] alucode;       // 演算種別
    input  [31:0] op1;          // 入力データ1
    input  [31:0] op2;          // 入力データ2
    output reg [31:0] alu_result;   // 演算結果
    output reg br_taken;             // 分岐の有無
always @(*)begin
    if(alucode == `ALU_ADD) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SUB) begin
        alu_result <= op1 - op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SLT) begin
        alu_result <= ($signed(op1) < $signed(op2)) ? 1 : 0;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SLTU) begin
        alu_result <= (op1 < op2)? 1:0;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_XOR) begin
        alu_result <=  op1 ^ op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_OR) begin
        alu_result <= op1 | op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_AND) begin
        alu_result <= op1 & op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SLL) begin
        alu_result <= (op1 << op2);
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SRL) begin
        alu_result <= (op1 >> op2);
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SRA) begin
        alu_result <= ($signed(op1) >>> op2);
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_JAL) begin  //ここから合ってるか不安 pcの値とか enableとかdisableとかだけ判定してレジスタとかにアクセスするのはdecoderで？
        alu_result <= op2 + 4;
        br_taken <= `ENABLE;
    end
    else if(alucode == `ALU_JALR) begin
        alu_result <= op2 + 4;
        br_taken <= `ENABLE;
    end
    else if(alucode == `ALU_BEQ) begin
       if(op1 == op2)begin
           alu_result <= 0;
           br_taken <= `ENABLE;
       end 
       else begin
          alu_result <= 0;
          br_taken <= `DISABLE; 
       end
    end
    else if(alucode == `ALU_BNE) begin
        if(op1 != op2)begin
           alu_result <= 0;
           br_taken <= `ENABLE;
       end 
       else begin
          alu_result <= 0;
          br_taken <= `DISABLE; 
       end
    end
    else if(alucode == `ALU_BLTU) begin
        if(op1 < op2)begin
           alu_result <= 0;
           br_taken <= `ENABLE;
       end 
       else begin
          alu_result <= 0;
          br_taken <= `DISABLE; 
       end
    end
    else if(alucode == `ALU_BLT) begin
        if($signed(op1) < $signed(op2))begin
           alu_result <= 0;
           br_taken <= `ENABLE;
       end 
       else begin
          alu_result <= 0;
          br_taken <= `DISABLE; 
       end
    end
    else if(alucode == `ALU_BGEU) begin
        if(op1 > op2 || op1 == op2)begin
           alu_result <= 0;
           br_taken <= `ENABLE;
       end 
       else begin
          alu_result <= 0;
          br_taken <= `DISABLE; 
       end
    end
    else if(alucode == `ALU_BGE) begin
        if($signed(op1) > $signed(op2) || $signed(op1)==$signed(op2))begin
           alu_result <= 0;
           br_taken <= `ENABLE;
       end 
       else begin
          alu_result <= 0;
          br_taken <= `DISABLE; 
       end
    end
    else if(alucode == `ALU_LB) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_LH) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_LW) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_LBU) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_LHU) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SB) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SH) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_SW) begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
    end
    else if(alucode == `ALU_LUI) begin 
        alu_result <= op2;
        br_taken <= `DISABLE;
    end
    else begin
        ;
    end
end
endmodule