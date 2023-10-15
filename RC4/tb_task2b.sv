module tb_task2b;
	logic clk, start, wren, t_done, wren_ram;
	logic [7:0] mem_out, rom_q, mem_address, mem_data, ram_data;
	logic [23:0] secret_key;
	logic [4:0] ram_addr, rom_addr;

	task2b duttt(
			.clk(clk),
			.sig_start(start),
			.t_done(t_done),
			.rom_addr(rom_addr),
			.rom_data(rom_q),
			.wren_ram(wren_ram),
			.ram_addr(ram_addr),
			.mem_out(mem_out),
			.ram_data(ram_data),
			.mem_data(mem_data),
			.mem_address(mem_address),
			.wren(wren)
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
	#10;
	//idle

	start = 1'b1;
	//incrementi 
	#10;
	//geti1
	#10;
	//geti2
	#10;
	//geti3
	#10;
	//getj1
	#10;
	//getj2
	#10;
	//getj3
	#10;
	//getj4
	#10;
	//si2sj
	#10;
	//siwritesj
	#10;
	//siwritesjwait
	#10;
	//sj2si
	#10;
	//sjwrite2si
	#10;
	//sjwrite2siwait
	#10;
	//getf
	#10;
	//getf1
	#10;
	//getf2
	#10;
	//xor
	#10;
	//write
	#10;
	//writek
	#10;
	//writek
	#10;
	//incrementk
	#10;
	//finish

	#100;
	$stop;
end

endmodule