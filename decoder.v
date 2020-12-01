`include "define.vh"

module decoder(
    ir,           // 機械語命令列
    srcreg1_num,
    srcreg2_num,
    dstreg_num,
    imm,
    alucode,
    aluop1_type,
    aluop2_type,
    reg_we,
    is_load,
    is_store,
    is_halt
);
    input   [31:0]  ir;           // 機械語命令列
    output reg [4:0]	srcreg1_num;  // ソースレジスタ1番号
    output reg [4:0]	srcreg2_num;  // ソースレジスタ2番号
    output reg [4:0]	dstreg_num;   // デスティネーションレジスタ番号
    output reg [31:0]	imm;          // 即値
    output reg [5:0]	alucode;      // ALUの演算種別
    output reg [1:0]	aluop1_type;  // ALUの入力タイプ
    output reg [1:0]	aluop2_type;  // ALUの入力タイプ
    output reg     	    reg_we;       // レジスタ書き込みの有無
    output reg 	        is_load;      // ロード命令判定フラグ
    output reg		    is_store;     // ストア命令判定フラグ
    output reg          is_halt;

wire [6:0] op;
wire [3:0] check;
wire [6:0] chk7bit;

assign op = ir[6:0];
assign check = ir[14:12];
assign chk7bit = ir[31:25];
always @(*)begin
//    op <= ir[6:0];
//    check <= ir[14:12];
    case(op)
        `LUI    :  begin
                    alucode <= `ALU_LUI;
                    srcreg1_num <= 5'b0;
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {ir[31:12],{12{1'b0}}};
                    aluop1_type <= `OP_TYPE_NONE;
                    aluop2_type <=`OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
        `AUIPC  :  begin
                    alucode <= `ALU_ADD;
                    srcreg1_num <= 5'b0;
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {ir[31:20],{20{1'b0}}};
                    aluop1_type <= `OP_TYPE_IMM;
                    aluop2_type <=`OP_TYPE_PC;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
        `JAL    : begin
                    alucode <= `ALU_JAL;
                    srcreg1_num <= 5'b0;
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{11{ir[31]}},ir[31],ir[19:12],ir[20],ir[30:21],{1'b0}};
                    aluop1_type <= `OP_TYPE_NONE;
                    aluop2_type <= `OP_TYPE_PC;
                    if(dstreg_num == 5'b00000)begin
                        reg_we <= `DISABLE;
                    end
                    else begin
                        reg_we <= `ENABLE;
                    end
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
        `JALR   : begin
                    alucode <= `ALU_JALR;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_PC;
                    if(dstreg_num == 5'b00000)begin
                        reg_we <= `DISABLE;
                    end
                    else begin
                        reg_we <= `ENABLE;
                    end
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
        `BRANCH :
            case(check)
                3'b000:begin
                    alucode <= `ALU_BEQ;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b001:begin
                    alucode <= `ALU_BNE;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b100:begin
                    alucode <= `ALU_BLT;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b101:begin
                    alucode <= `ALU_BGE;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b110:begin
                    alucode <= `ALU_BLTU;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b111:begin
                    alucode <= `ALU_BGEU;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{19{ir[31]}},ir[31],ir[7],ir[30:25],ir[11:8],{1'b0}};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                default: ;
            endcase
        `LOAD   :
            case(check)
                3'b000:begin
                    alucode <= `ALU_LB;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `ENABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b001:begin
                    alucode <= `ALU_LH;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `ENABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b010:begin
                    alucode <= `ALU_LW;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `ENABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b100:begin
                    alucode <= `ALU_LBU;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `ENABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b101:begin
                    alucode <= `ALU_LHU;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `ENABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                default: ;
            endcase
        `STORE  :
            case(check)
                3'b000:begin
                    alucode <= `ALU_SB;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{20{ir[31]}},ir[31:25],ir[11:7]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `ENABLE;
                    is_halt <= `DISABLE;
                end
                3'b001:begin
                    alucode <= `ALU_SH;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{20{ir[31]}},ir[31:25],ir[11:7]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `ENABLE;
                    is_halt <= `DISABLE;
                end
                3'b010:begin
                    alucode <= `ALU_SW;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= 5'b0;
                    imm <= {{20{ir[31]}},ir[31:25],ir[11:7]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `DISABLE;
                    is_load <= `DISABLE;
                    is_store <= `ENABLE;
                    is_halt <= `DISABLE;
                end
                default: ;
            endcase
        `OPIMM  :// 即値の扱い注意
            case(check)
                3'b000:begin
                    alucode <= `ALU_ADD;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end 
                3'b001: begin
                    alucode <= `ALU_SLL;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{27{ir[24]}},ir[24:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b010: begin
                    alucode <= `ALU_SLT;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b011: begin
                    alucode <= `ALU_SLTU;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b100: begin
                    alucode <= `ALU_XOR;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b101: begin
//                    chk7bit <= ir[31:25];
                    if(chk7bit == 7'b0000000)begin
                        alucode <= `ALU_SRL;
                    end
                    else if(chk7bit == 7'b0100000)begin
                        alucode <= `ALU_SRA;
                    end
                    else begin
                        ;
                    end
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{27{ir[24]}},ir[24:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b110: begin
                    alucode <= `ALU_OR;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b111: begin
                    alucode <= `ALU_AND;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= 5'b0;
                    dstreg_num <= ir[11:7];
                    imm <= {{20{ir[31]}},ir[31:20]};
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_IMM;
                    reg_we <= `ENABLE;
                    is_load <= `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                default: ;
            endcase
        `OP    :
            case(check)
                3'b000:begin
//                    chk7bit <= ir[31:25];
                    if(chk7bit == 7'b0000000)begin
                        alucode <= `ALU_ADD;
                    end
                    else if(chk7bit == 7'b0100000)begin
                        alucode <= `ALU_SUB;
                    end
                    else begin
                        ;
                    end
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b001:begin
                    alucode <= `ALU_SLL;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b010: begin
                    alucode <= `ALU_SLT;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b011: begin
                    alucode <= `ALU_SLTU;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b100: begin
                    alucode <= `ALU_XOR;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b101: begin
//                    chk7bit <= ir[31:25];
                    if(chk7bit == 7'b0000000)begin
                        alucode <= `ALU_SRL;
                    end
                    else if(chk7bit == 7'b0100000)begin
                        alucode <= `ALU_SRA;
                    end
                    else begin
                        ;
                    end
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b110: begin
                    alucode <= `ALU_OR;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                3'b111: begin
                    alucode <= `ALU_AND;
                    srcreg1_num <= ir[19:15];
                    srcreg2_num <= ir[24:20];
                    dstreg_num <= ir[11:7];
                    imm <= 32'h0;
                    aluop1_type <= `OP_TYPE_REG;
                    aluop2_type <= `OP_TYPE_REG;
                    reg_we <= `ENABLE;
                    is_load <=  `DISABLE;
                    is_store <= `DISABLE;
                    is_halt <= `DISABLE;
                end
                default: ;
            endcase
        default : ;
    endcase
end
endmodule