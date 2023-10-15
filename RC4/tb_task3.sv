module tb_task3;

	logic clk, start, task3_continue, task3_done;
	reg [7:0] ram_q = 0;
	logic [4:0] ram_addr_3;

	task3 dutttt (
			.clk(CLOCK_50),
			.sig_start(task3_start),
			.task3_done(task3_done),
			.task3_continue(task3_continue),
			.data_in(ram_q),
			.task3_addr(ram_addr_3)
			);


	initial begin
		forever begin
			clk = 1'b1;
			#5;
			clk = 1'b0;
			#5;
		end
	end

	initial begin
		#10; // stay in idle

		start = 1'b1;

		#10;
		//setaddr

		#10;
		//setaddr

		#10;
		//continue

		#10; 

		#100;
		$stop;
	end

endmodule