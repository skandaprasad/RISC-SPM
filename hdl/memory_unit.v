// A simple unit of memory can be arranged as an array of D flipflops

module memory_unit (
    data_out,
    data_in,
    address,
    clk,
    write
);

  parameter DATAWIDTH = 8;
  parameter memory_size = 256;

  output reg ; [DATAWIDTH - 1:0] data_out;
  input [DATAWIDTH - 1:0] data_in;
  input [DATAWIDTH - 1:0] address;
  input clk, write;
  
  reg [DATAWIDTH - 1:0] memory [memory_size - 1:0];
   
  assign data_out = memory[address];

  always @ (posedge clk)
  begin
      if(write)
      memory[address] <= data_in;
  end
endmodule