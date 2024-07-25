

module ram_fpga2(clk_1hz,addr,data,write_en,data_out);
input clk_1hz;
input [3:0] addr;
input [3:0] data;
input write_en;
output reg [3:0] data_out;
reg [3:0] RAM [15:0];
always @ (posedge clk_1hz) begin
if(write_en)
  RAM[addr]<=data;
assign data_out=RAM[addr];
   end
endmodule

