module task2a_tb ();

logic clk, start, wen, finished;
logic [7:0] q, data, address;
logic [23:0] secret_key;

task2a DUT (.clk(clk), 
						.start(start), 
						.wen(wen), 
						.finished(finished), 
						.q(q), 
						.data(data), 
						.address(address), 
						.secret_key(secret_key));

initial begin
	forever begin
		clk = 1'b1;
		#10;
		clk = 1'b0;
		#10;
	end
end

initial begin
	#10; // Stay in idle
	//IDLE
	start = 1'b1; 
	//START
	#20;
	//UPDATE_ADDRESS1
	#20;
	//FETCH_MEM1 => s_i_en is asserted
	#20;
	//FETCH_MEM1_WAIT => s_i_en is asserted
	#20;
	//UPDATE_J
	#20;
	//UPDATE_ADDRESS2
	#20;
	//FETCH_MEM2 => s_j_en is asserted
	#20;
	//FETCH_MEM2_WAIT => s_j_en is asserted
	#20;
	//UPDATE_DATA1
	#20;
	//WRITE_MEM1 => wen is asserted
	#20;
	//WRITE_MEM1_WAIT => wen is asserted
	#20;
	//UPDATE_DATA2
	#20;
	//WRITE_MEM2 => wen is asserted
	#20;
	//WRITE_MEM2_WAIT => wen is asserted
	#20;
	//INCREMENT_I
	#20;
	//FINISH => finished is asserted

	#200;
	$stop;
end

endmodule