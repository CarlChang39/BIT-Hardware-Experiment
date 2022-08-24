`timescale 1ns / 1ps

module buffer3(
    input clk,
    input rst,
    input i_flush,
    // cmd
    input i_reg_we,
    input i_reg_wc,
    input i_dmem_we,
    input i_br,
    input i_jmp,
    // data
    input [31:0] i_alu_res,
    input [31:0] i_dmem_wdata, // reg2_data
    input [4:0] i_reg_waddr,
    input [31:0] i_pc,
    // cmd
    output o_reg_we,
    output o_reg_wc,
    output o_dmem_we,
    output o_jc, // jump control
    // data
    output [31:0] o_alu_res,
    output [31:0] o_dmem_wdata,
    output [4:0] o_reg_waddr,
    output [31:0] o_pc
    );
    // cmd
    reg buf_reg_we, buf_reg_wc, buf_dmem_we, buf_br, buf_jmp;
    assign o_reg_we = buf_reg_we;
    assign o_reg_wc = buf_reg_wc;
    assign o_dmem_we = buf_dmem_we;
    
    always @(posedge clk or negedge rst) begin
        if(~rst | i_flush) begin
            buf_reg_we <= 0;
            buf_reg_wc <= 0;
            buf_dmem_we <= 0;
            buf_br <= 0;
            buf_jmp <= 0;
        end
        else begin
            buf_reg_we <= i_reg_we;
            buf_reg_wc <= i_reg_wc;
            buf_dmem_we <= i_dmem_we;
            buf_br <= i_br;
            buf_jmp <= i_jmp;
        end
    end
    // data
    reg [31:0] buf_alu_res;
    reg [31:0] buf_dmem_wdata;
    reg [4:0] buf_reg_waddr;
    reg [31:0] buf_pc;
    assign o_jc = buf_jmp | (buf_br & (buf_alu_res[0] == 1));
    assign o_alu_res = buf_alu_res;
    assign o_dmem_wdata = buf_dmem_wdata;
    assign o_reg_waddr = buf_reg_waddr;
    assign o_pc = buf_pc;
    always @(posedge clk or negedge rst) begin
        if(~rst | i_flush) begin
            buf_alu_res <= 0;
            buf_dmem_wdata <= 0;
            buf_reg_waddr <= 0;
            buf_pc <= 0;
        end
        else begin
            buf_alu_res <= i_alu_res;
            buf_dmem_wdata <= i_dmem_wdata;
            buf_reg_waddr <= i_reg_waddr;
            buf_pc <= i_pc;
        end
    end
endmodule
