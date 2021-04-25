module program_counter(
    count,
    data_in,
    ld_pc,
    inc_pc,
    clk,
    clr
);

parameter DATAWIDTH = 8;
output reg [DATAWIDTH - 1:0] count;
input [DATAWIDTH - 1:0] data_in;
input ld_pc, inc_pc, clk, clr;

// Clear is an active low signal

always @ (posedge clk or negedge clr)
begin
    if(!clr)
        count <= 0;
    else if (ld_pc)
        count <= data_in;
    else if (inc_pc)
        count <= count + 1;
end
    
endmodule