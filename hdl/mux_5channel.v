module mux_5channel (
    mux_out,
    in1,
    in2,
    in3,
    in4,
    in5,
    select
);

parameter DATAWIDTH = 8;
output [DATAWIDTH - 1:0] mux_out;
input [DATAWIDTH - 1:0] in1, in2, in3, in4, in5;
input [2:0] select;

assign mux_out = (select == 0) ? in1 : (select == 1) 
                               ? in2 : (select == 2)
                               ? in3 : (select == 3) 
                               ? in4 : (select == 4) 
                               ? in5 : 'bx; 
    
endmodule