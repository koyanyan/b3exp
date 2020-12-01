`include "define.vh"

module execution(
    imm,
    pc,
    alucode,
    aluop1_type,
    aluop2_type,
    // reg_we,
    // is_load,
    // is_store,
    // is_halt,
    rs1,
    rs2,    
    nextpc,
    result
);

    input   [31:0]  imm, pc;
    input   [31:0]  rs1, rs2;
    input   [5:0]   alucode;
    input   [1:0]   aluop1_type,aluop2_type;
    // input   reg_we, is_load, is_store, is_halt;
    output  reg [31:0]  nextpc;
    output wire [31:0] result;

    reg     [31:0]  op1,op2;
always @(*)begin
    case(aluop1_type)
        `OP_TYPE_NONE:begin
            op1 <= 32'h0000000;
        end
        `OP_TYPE_REG:begin
            op1 <= rs1;
        end
        `OP_TYPE_IMM:begin
            op1 <= imm;
        end
        `OP_TYPE_PC:begin
            op1 <= pc;
        end
    endcase
    case(aluop2_type)
        `OP_TYPE_NONE:begin
            op2 <= 32'h0000000;
        end
        `OP_TYPE_REG:begin
            op2 <= rs2;
        end
        `OP_TYPE_IMM:begin
            op2 <= imm;
        end
        `OP_TYPE_PC:begin
            op2 <= pc;
        end
    endcase
end
    alu alu(
       .alucode(alucode),
       .op1(op1),
       .op2(op2),
       .alu_result(result),
       .br_taken(br)
    );
always @(*)begin
    if(br == `ENABLE)begin
        if(alucode == `ALU_JALR)begin
            nextpc <= rs1 + imm;
        end
        else begin
            nextpc <= pc + imm;
        end
    end
    else begin      //br == disable
        nextpc <= pc + 32'd4;
    end
end
endmodule