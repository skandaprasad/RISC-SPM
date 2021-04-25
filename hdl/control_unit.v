module control_unit(
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
    clr
);

parameter DATAWIDTH = 8;
parameter opcode_size = 4;
parameter state_size = 4;

parameter src_size = 2;
parameter dest_size = 2;
parameter sel1_size = 3;
parameter sel2_size = 2;

// State codes

parameter idle = 0;
parameter fetch1 = 1;
parameter fetch2 = 2;
parameter decode = 3;
parameter execute = 4;
parameter read1 = 5;
parameter read2 = 6;
parameter write1 = 7;
parameter write2 = 8;
parameter branch1 = 9;
parameter branch2 = 10;
parameter halt = 11;

// Op-codes

parameter NOP = 0;
parameter ADD = 1;
parameter SUB = 2;
parameter AND = 3;
parameter NOT = 4;
parameter RD = 5;
parameter WR = 6;
parameter BR = 7;
parameter BRZ = 8;

// Source & Destination codes

parameter R0 = 0;
parameter R1 = 1;
parameter R2 = 2;
parameter R3 = 3;

output reg ld_r0, ld_r1, ld_r2, ld_r3, ld_pc, inc_pc, ld_ir, ld_address_reg, ld_reg_y, ld_reg_z, write;
output [sel1_size - 1:0] sel_bus1_mux;
output [sel2_size - 1:0] sel_bus2_mux;
input [DATAWIDTH - 1:0] instruction;
input zero, clk, clr;

reg [state_size - 1:0] state, next_state;
reg error_flag, sel_alu, sel_bus1, sel_mem, sel_r0, sel_r1, sel_r2, sel_r3, sel_pc;

wire [opcode_size - 1:0] opcode = instruction [DATAWIDTH - 1:DATAWIDTH - opcode_size];
wire [src_size - 1:0] src = instruction [src_size + dest_size - 1:dest_size];
wire [dest_size - 1:0] dest = instruction [dest_size - 1:0];

// Mux selectors

assign sel_bus1_mux [sel1_size - 1:0] = sel_r0 ? 0 : sel_r1 ? 1 : sel_r2 ? 2 : sel_r3 ? 3 : sel_pc ? 4 : 3'bx;
assign sel_bus2_mux [sel2_size - 1:0] = sel_alu ? 0 : sel_bus1 ? 1 : sel_mem ? 2 : 2'bx;

always @ (posedge clk or negedge clr)
begin
    if(!clr)
        state <= idle;
    else
        state <= next_state;
end

always @(state or opcode or src or dest or zero) begin
    sel_r0 = 0;
    sel_r0 = 0;
    sel_r0 = 0;
    sel_r0 = 0;
    sel_r0 = 0;

    ld_r0 = 0;
    ld_r1 = 0;
    ld_r2 = 0;
    ld_r3 = 0;

    ld_pc = 0;
    ld_ir = 0;
    ld_address_reg = 0;
    ld_reg_y = 0;
    ld_reg_z = 0;
    inc_pc = 0;
    sel_bus1 = 0;
    sel_alu = 0;
    sel_mem = 0;
    write = 0;
    error_flag = 0;
    next_state = state;

    case(state)
        idle: next_state = fetch1;
        fetch1: begin
            next_state = fetch2;
            sel_pc = 1;
            sel_bus1 = 1;
            ld_address_reg = 1;
        end

        fetch2: begin
            next_state = decode;
            sel_mem = 1;
            ld_ir = 1;
            inc_pc = 1;
        end

        decode: case (opcode)
                    NOP: next_state = fetch1;
                    ADD, SUB, AND: begin
                        next_state = execute;
                        sel_bus1 = 1;
                        ld_reg_y = 1;
                    case (src)
                        R0: sel_r0 = 1;
                        R1: sel_r1 = 1;
                        R2: sel_r2 = 1;
                        R3: sel_r3 = 1;
                        default: error_flag = 1;  
                    endcase
                    end

                    NOT: begin
                        next_state = fetch1;
                        ld_reg_z = 1;
                        sel_bus1 = 1;
                        sel_alu = 1;
                        case (src)
                        R0: sel_r0 = 1;
                        R1: sel_r1 = 1;
                        R2: sel_r2 = 1;
                        R3: sel_r3 = 1;
                        default: error_flag = 1;      
                        endcase

                    case (dest)
                        R0: ld_r0 = 1;
                        R1: ld_r1 = 1;
                        R2: ld_r2 = 1;
                        R3: ld_r3 = 1;
                        default: error_flag = 1;       
                    endcase
                    end
                    RD: begin
                        next_state = read1;
                        sel_pc = 1;
                        sel_bus1 = 1;
                        ld_address_reg = 1;
                    end

                    WR: begin
                        next_state = write1;
                        sel_pc = 1;
                        sel_bus1 = 1;
                        ld_address_reg = 1;
                    end

                    BR: begin
                        next_state = branch1;
                        sel_pc = 1;
                        sel_bus1 = 1;
                        ld_address_reg = 1;
                    end

                    BRZ: if(zero == 1) begin
                        next_state = branch1;
                        sel_pc = 1;
                        sel_bus1 = 1;
                        ld_address_reg = 1;
                    end
                    else begin
                        next_state = fetch1;
                        inc_pc = 1;
                    end
                    default: next_state = halt;
                endcase

        execute: begin
            next_state = fetch1;
            ld_reg_z = 1;
            sel_alu = 1;
            case(dest)
                R0: begin sel_r0 = 1; ld_r0 = 1; end
                R1: begin sel_r1 = 1; ld_r1 = 1; end
                R2: begin sel_r2 = 1; ld_r2 = 1; end
                R3: begin sel_r3 = 1; ld_r3 = 1; end
                default: error_flag = 1;
        endcase
        end

        read1: begin
            next_state = read2;
            sel_mem = 1;
            ld_address_reg = 1;
            inc_pc = 1;
        end

        write1: begin
            next_state = write2;
            sel_mem = 1;
            ld_address_reg = 1;
            inc_pc = 1;
        end 

        read2: begin
            next_state = fetch1;
            sel_mem = 1;
            case (dest)
                R0: ld_r0 = 1; 
                R1: ld_r1 = 1; 
                R2: ld_r2 = 1; 
                R3: ld_r3 = 1; 
                default: error_flag = 1;
            endcase
        end

        write2: begin
            next_state = fetch1;
            write = 1;
            case (src)
            R0: sel_r0 = 1;
            R1: sel_r1 = 1;
            R2: sel_r2 = 1;
            R3: sel_r3 = 1;
            default: error_flag = 1;  
            endcase
        end

        branch1: begin
            next_state = branch2;
            sel_mem = 1;
            ld_address_reg = 1;
        end

        branch2: begin
            next_state = fetch1;
            sel_mem = 1;
            ld_pc = 1;
        end

        halt: next_state = halt;
        default: next_state = idle;
endcase
end
endmodule   



