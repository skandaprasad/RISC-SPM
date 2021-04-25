module instruction_register(
    data_out,
    data_in,
    load,
    clk,
    clr
);

parameter DATAWIDTH = 8;
output reg [DATAWIDTH - 1:0] data_out;
input [DATAWIDTH - 1:0] data_in;
input load, clk, clr;

// Clear is an active low signal

always @ (posedge clk or negedge clr)
begin
    if(!clr)
        data_out <= 0;
    else if (load) begin
        data_in <= data_in;
    end
end
    
endmodule