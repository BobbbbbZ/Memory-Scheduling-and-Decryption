module clk_divider (input logic inclk,input logic rst, input logic [31:0] div, output logic outclk);

	logic [31:0] counter;
	
	always_ff @(posedge inclk, negedge rst) begin
		if (~rst) counter <= 32'b0;
		else if (counter >= div - 1) counter <= 32'b0;
		else counter <= counter + 1;	
	end
	
	always_ff @ (posedge inclk, negedge rst) begin
		if (~rst) outclk <= 1'b0;
		else if (counter >= div - 1) outclk <= ~outclk;
		else outclk <= outclk;
	end	
endmodule