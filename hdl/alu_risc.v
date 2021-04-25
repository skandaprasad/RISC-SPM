module alu_risc (
    alu_zero_flag,
    alu_out,
    data_1, 
    data_2,
    select
);

  /* ALU Instruction                Action
    ADD                             Adds datapaths to form data_1 + data_2
    SUB                             Subtracts datapaths to form data_1 - data_2
    AND                             Takes bitwise and of datapaths data_1 and data_2
    NOT                             Takes bitwise boolean complement of data_1
  */

  parameter DATAWIDTH = 8;
  parameter opcode_size = 4;

  // Op-codes 
  parameter NOP = 4'b0000;
  parameter ADD = 4'b0001;
  parameter SUB = 4'b0010;
  parameter AND = 4'b0011;
  parameter NOT = 4'b0100;
  parameter RD = 4'b0101;
  parameter WR = 4'b0110;
  parameter BR = 4'b0111;
  parameter BRZ = 4'b1000;

  //Port declarations
  output alu_zero_flag;
  output reg [DATAWIDTH - 1:0] alu_out;
  input [DATAWIDTH - 1:0]  data_1. data_2;
  input [opcode_size - 1:0] select;

  assign alu_zero_flag = ~|alu_out;

  always @ (sel or data_1 or data_2)
  begin
      case(select)
        NOP: alu_out = 0;
        ADD: alu_out = data_1 + data_2;
        SUB: alu_out = data_1 - data_2;
        AND: alu_out = data_1 & data_2;
        NOT: alu_out = ~data_2; // WTF is going on
        default: alu_out = 0;
      endcase
  end
endmodule