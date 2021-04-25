module top(
  clk,
  clr 
);
    parameter DATAWIDTH = 8;
    parameter sel1_size = 3;
    parameter sel2_size = 2; 
    wire [sel1_size - 1:0] sel_bus1_mux;
    wire [sel2_size - 1:0] sel_bus2_mux;
    input clk, clr;

    //Data nets
    wire zero;
    wire [DATAWIDTH - 1:0] instruction, address, bus1, mem_word;    

    //Control nets
    wire ld_r0, ld_r1, ld_r2, ld_r3, ld_pc, inc_pc, ld_ir;
    wire ld_address_reg, ld_reg_y, ld_reg_z;
    wire write;

  processing_unit processor(
    instruction, 
    zero, 
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

    control_unit controller(
    ld_r0, 
    ld_r1, 
    ld_r2,
    ld_r3,
    ld_pc,
    inc_pc,
    sel_bus1_mux,
    sel_bus2_mux,
    ld_ir,
    ld_address_reg,
    ld_reg_y,
    ld_reg_z,
    write,
    instruction,
    zero, 
    clk,
    clr,
    );

    memory_unit RAM(
    .data_out(mem_word),
    .data_in(bus)
    .address(address),
    .clk(clk),
    .write(write)
    );

endmodule

