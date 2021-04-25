module processing_unit (
    instruction,
    zero_flag,
    address,
    bus1,
    mem_word,
    ld_r0,
    ld_r1,
    ld_r2,
    ld_r3,
    ld_pc,
    inc_pc,
    sel_bus1_mux,
    ld_ir,
    ld_address_reg,
    ld_reg_y,
    ld_reg_z,
    sel_bus2_mux,
    clk,
    clr
);

// Parameters declaration

parameter DATAWIDTH = 8;
parameter opcode_size = 4;
parameter sel1_size = 3;
parameter sel2_size = 2; 

// Ports declaration

output [DATAWIDTH - 1:0] instruction, address, bus1;
output zero_flag;

input [DATAWIDTH - 1:0] mem_word;
input ld_r0, ld_r1, ld_r2, ld_r3, ld_pc, inc_pc;

input [sel1_size - 1:0] sel_bus1_mux;
input [sel2_size - 1:0] sel_bus2_mux;

input ld_ir, ld_address_reg, ld_reg_z, ld_reg_y, clk, clr;

// Intermediate wires declaration

wire  ld_r0, ld_r1, ld_r2, ld_r3;
wire [DATAWIDTH - 1:0] bus2;
wire [DATAWIDTH - 1:0] out_r0, out_r1, out_r2, out_r3,;
wire [DATAWIDTH - 1:0] pc_count, out_reg_y, alu_out;
wire alu_zero_flag;
wire [opcode_size - 1:0] opcode = instruction [DATAWIDTH - 1:DATAWIDTH - opcode_size];

// Instantiations of register units, flipflops, address register, instruction register, program counter, ALU and Multiplexers

register_unit R0 (out_r0, bus2, ld_r0, clk, clr);
register_unit R1 (out_r1, bus2, ld_r1, clk, clr);
register_unit R2 (out_r2, bus2, ld_r2, clk, clr);
register_unit R3 (out_r3, bus2, ld_r3, clk, clr);
register_unit REG_Y (out_reg_y, bus2, ld_reg_y, clk, clr);
dff REG_Z (zero_flag, alu_zero_flag, ld_reg_z, clk, clr);
address_register ADDR_REG (address, bus2, ld_address_reg, clk, clr);
instruction_register IR (instruction, bus2, ld_ir, clk, clr);
program_counter PC (pc_count, bus2, ld_pc, inc_pc, clk, clr);
mux_5channel MUX1 (bus1, out_r0, out_r1, out_r2, out_r3, pc_count, sel_bus1_mux);
mux_3channel MUX2 (bus2, alu_out, bus1, mem_word, sel_bus2_mux);
alu_risc ALU (alu_zero_flag, alu_out, out_reg_y, bus1, opcode);

endmodule