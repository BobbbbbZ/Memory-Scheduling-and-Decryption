module tb_task1();
logic clk, start, wren, t_done;
logic [7:0] data, address;

	task1 dut(
			.clk(clk),
			.mem_address(address),
			.mem_data(data),
			.sig_start(start), 
			.wren(wren),
			.t_done(t_done)
			); 

initial begin
	forever begin
		clk = 1'b1;
		#10;
		clk = 1'b0;
		#10;
	end
end

initial begin
	start = 1'b0;
	#10; // Stay in idle

	start = 1'b1; // Assert start = 1, begin fsm

	#20;

	start = 1'b0; // Deassert start = 0

	#4500 // Wait for memory to be initialized and finished to be asserted

	$stop;
end

endmodule