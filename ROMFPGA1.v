


module ROMFPGA1(input clk,//100 Mhz from Nexys
output o_1hz,//modifying clk
output x_1hz, //led indicator
output wr_en, // to basys ram
output [3:0] o_addr, // to basys ram
output [3:0]o_data,// to basys ram
output [3:0] leds);// 4 LEDs on basys1,rom data out

wire w_1hz;
wire [3:0] w_addr;
wire [3:0] w_data;

rom g1(.addr(w_addr),.data(w_data));
rom_control g2(.clk_1hz(w_1hz),.addr(w_addr),.wr_en(wr_en));
onehz_gen uno(.clk(clk),.clk_1hz(w_1hz));

assign o_addr = w_addr;
assign o_data =w_data;
assign leds = w_data;
assign o_1hz = w_1hz;
assign x_1hz = o_1hz;
endmodule


module onehz_gen(input clk,output clk_1hz);//clk is 100mhz from basys1
reg [25:0]r_counter=0;reg r_clk_1hz=0;
always@(posedge clk)begin
if(r_counter==49_999_99)begin
r_counter<=0;
r_clk_1hz<=~clk_1hz;
end
else
r_counter<=r_counter+1;
end
assign clk_1hz=r_clk_1hz;
endmodule

module rom(input [3:0]addr // memory address
,output reg [3:0]data);//data at each memory address

always@(*) begin
case(addr)
4'b0000:data<=4'h0;
4'b0001:data<=4'h1;
4'b0010:data<=4'h2;
4'b0011:data<=4'h3;
4'b0100:data<=4'h4;
4'b0101:data<=4'h5;
4'b0110:data<=4'h6;
4'b0111:data<=4'h7;
4'b1000:data<=4'h8;
4'b1001:data<=4'h9;
4'b1010:data<=4'hA;
4'b1011:data<=4'hB;
4'b1100:data<=4'hC;
4'b1101:data<=4'hD;
4'b1110:data<=4'hE;
4'b1111:data<=4'hF;
endcase 
end 
endmodule

module rom_control(input clk_1hz,output [3:0]addr,output reg wr_en);
//counter control logic
reg[3:0]addr_ctr=0;
always@(posedge clk_1hz)
  addr_ctr<=addr_ctr+1;
  //state machine parameters
parameter read_rom=2'b00;
parameter write_ram=2'b01;
parameter read_ram=2'b10;
reg [1:0] state_reg =read_rom; //state register
//next state logic
always@(posedge clk_1hz)
begin
case(state_reg)//present state
read_rom:if(addr_ctr==15)
          state_reg<=write_ram;
write_ram:begin
          wr_en=1;
          if(addr_ctr==15)
          state_reg<=read_ram;
          end 
read_ram:begin
         wr_en=0;
         if(addr_ctr==15)
         state_reg<=read_rom;
         end     
endcase
end
assign addr=addr_ctr;
endmodule
