module ram(clk, we,re, r_addr, r_data, w_addr, w_data); 
             input clk;
             input [3:0] we,re;
             input  [4:0] r_addr, w_addr;
             input  [31:0] w_data;
             output reg [31:0] r_data;
             reg [7:0] mem [0:65536];             //32bitのレジスタが32個(アドレスは5bit)
             // 32KiB = 32768bit
             
//initial begin
//    for (integer i = 0; i < 98303; i = i + 1) mem[i] <= 32'h0;
//end
    initial $readmemh("/home/denjo/exp/b3exp/benchmarks/Coremark_for_Synthesis/data.hex", mem);

             always @(negedge clk) begin
                if(we[0]) mem[w_addr] <= w_data[ 7: 0];
                if(we[1]) mem[w_addr + 5'd1] <= w_data[15: 8];
                if(we[2]) mem[w_addr + 5'd2] <= w_data[23:16];
                if(we[3]) mem[w_addr + 5'd3] <= w_data[31:24];
            end
            always @(*)begin
                if(re[0]) r_data[7:0] <= mem[r_addr];
                else      r_data[7:0] <= 8'h00;
                if(re[1]) r_data[15:8] <= mem[r_addr+5'd1];
                else      r_data[15:8] <= {8{mem[r_addr][7]}};
                if(re[2]==1 && re[3]==1) begin
                    r_data[23:16] <= mem[r_addr+5'd2];
                    r_data[31:24] <= mem[r_addr+5'd3];
                end
                else begin
                    if(re[1] == 1)begin
                        r_data[31:16] <= {16{mem[r_addr+5'd1][7]}};
                    end
                    else begin
                        r_data[31:8] <= {24{mem[r_addr][7]}};
                    end
                end
            end
	 endmodule
