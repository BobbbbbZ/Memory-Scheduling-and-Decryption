module tb_task2a;

logic clk, start, wren, t_done;
logic [7:0] mem_out, data, address;
logic [23:0] secret_key;

	task2a dutt(
				.clk(clk), 
				.sig_start(start), 
				.t_done(t_done), 
				.key(secret_key),
				.data_in(mem_out), 
				.t_write(wren),
				.mem_data(data), 
				.mem_address(address)
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
	//idle
	start = 1'b1; 
	//initial value
	#10;
	//checki
	#10;
	//geti_1 
	#10;
	//geti_2 
	#10;
	//geti_3
	#10;
	//geti_4
	#10;
	//getj_1
	#10;
	//getj_2
	#10;
	//getj_3
	#10;
	//getj_4
	#10;
	//swap
	#10;
	//sj2si
	#10;
	//sjwrite2si
	#10;
	//si2sj
	#10;
	//siwrite2sj
	#10;
	//increment
	#10;
	//checki
	
	#100;
	$stop;
end

endmodule