module dff (
   output reg data_out,
   input data_in,
   input load,
   input clk,
   input clr
);

  always @ (posedge clk or negedge clr)
  begin
      if(!clr)
        data_out <= 0;
      else if (load) begin
        data_in <= data_in;
    end
  end

endmodule