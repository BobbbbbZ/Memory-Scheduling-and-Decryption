module ksa (
			input CLOCK_50,
			input [3:0] KEY, 
			input [9:0] SW, 
			output [9:0] LEDR,
			output [6:0] HEX0, 
			output [6:0] HEX1, 
			output [6:0] HEX2, 
			output [6:0] HEX3, 
			output [6:0] HEX4, 
			output [6:0] HEX5
			); 


	SevenSegmentDisplayDecoder hex0 (.ssOut(HEX0), .nIn(secret_key[3:0]));
	SevenSegmentDisplayDecoder hex1 (.ssOut(HEX1), .nIn(secret_key[7:4]));
	SevenSegmentDisplayDecoder hex2 (.ssOut(HEX2), .nIn(secret_key[11:8]));
	SevenSegmentDisplayDecoder hex3 (.ssOut(HEX3), .nIn(secret_key[15:12]));
	SevenSegmentDisplayDecoder hex4 (.ssOut(HEX4), .nIn(secret_key[19:16]));
	SevenSegmentDisplayDecoder hex5 (.ssOut(HEX5), .nIn(secret_key[23:20]));


  	reg [23:0] secret_key; 

	// memory
	logic wren;
	logic [7:0] mem_address, mem_data, mem_out;
	logic wren_ram;
	logic [4:0] ram_addr; 
	logic [7:0] ram_data, ram_q;
	logic [4:0] rom_addr;
	logic [7:0] rom_q;
	
	// task1
	logic task1_start, task1_done, wren_1;
	logic [7:0] mem_address_1, mem_data_1;

	// task2a
	logic task2a_start, task2a_done, wren_2a;
	logic [7:0] mem_address_2a, mem_data_2a;
	// task2b
	logic task2b_start, task2b_done, wren_2b, wren_ram_2b;
	logic [4:0] rom_addr_2b, ram_addr_2b;
	logic [7:0] mem_address_2b, mem_data_2b,  ram_data_2b;
	// task3
	logic task3_start, task3_continue, task3_done;
	logic [4:0] ram_addr_3;   

	s_memory memory (.address(mem_address),
				.clock(CLOCK_50),
				.data(mem_data),
				.wren(wren),
				.q(mem_out)
				);

	
	decrypt_ram ram (.address(ram_addr),
					.clock(CLOCK_50),
					.data(ram_data),
					.wren(wren_ram),
					.q(ram_q)
					);   

	
	rom rom(.address(rom_addr),
			.clock(CLOCK_50),
			.q(rom_q)
			);                                                       

	
	task1 dut(
			.clk(CLOCK_50),
			.mem_address(mem_address_1),
			.mem_data(mem_data_1),
			.sig_start(task1_start), 
			.wren(wren_1), 
			.t_done(task1_done)
			); 
			
			
	
	task2a dutt(
				.clk(CLOCK_50), 
				.sig_start(task2a_start), 
				.t_done(task2a_done), 
				.key(secret_key),
				.data_in(mem_out), 
				.t_write(wren_2a),
				.mem_data(mem_data_2a), 
				.mem_address(mem_address_2a)
			);

	
	task2b duttt(
			.clk(CLOCK_50),
			.sig_start(task2b_start),
			.t_done(task2b_done),
			.rom_addr(rom_addr_2b),
			.rom_data(rom_q),
			.wren_ram(wren_ram_2b),
			.ram_addr(ram_addr_2b),
			.mem_out(mem_out),
			.ram_data(ram_data_2b),
			.mem_data(mem_data_2b),
			.mem_address(mem_address_2b),
			.wren(wren_2b)
			);
			
			
             

task3 dutttt (
		.clk(CLOCK_50),
		.sig_start(task3_start),
		.task3_done(task3_done),
		.task3_continue(task3_continue),
		.data_in(ram_q),
		.task3_addr(ram_addr_3)
		);

    

	parameter idle               		= 10'b00_0000_0000;
	parameter task1_go            		= 10'b00_0001_0001;        
	parameter task1_wait  				= 10'b00_0001_0000; 
	parameter task2a_go              	= 10'b00_0010_0010;        
	parameter task2a_wait   			= 10'b00_0010_0000; 
	parameter task2b_go              	= 10'b00_0100_0100;
	parameter task2b_wait    			= 10'b00_0100_0000;
	parameter task3_go                  = 10'b00_1000_1000;
	parameter task3_wait     			= 10'b00_1000_0000;
	parameter increment_secret_key      = 10'b01_0000_0000;
	parameter finish                    = 10'b10_0000_0000; 

	logic [3:0] fsm;
	reg [9:0] state = idle;

	assign fsm = state[7:4];
	assign task1_start = state[0];
	assign task2a_start = state[1];
	assign task2b_start = state[2];
	assign task3_start  = state[3];

	// rc4 state machine
	always_ff @(posedge CLOCK_50) begin
		if (~KEY[1]) begin
			state <= idle;
			end
		else begin
		case(state)
			idle: if (~KEY[0]) begin
			secret_key <= 0;
			LEDR <= 0;
			state <= task1_go;
			end

			task1_go: state <= task1_wait;

			task1_wait: if (task1_done) begin
			state <= task2a_go;
			end

			task2a_go: state <= task2a_wait;

			task2a_wait: if (task2a_done) begin
			state <= task2b_go;
			end

			task2b_go: state <= task2b_wait;

			task2b_wait: if (task2b_done) begin
			state <= task3_go;
			end

			task3_go: state <= task3_wait;

			task3_wait: if (task3_done) begin
			if (task3_continue) begin
				state <= increment_secret_key;
			end
			else begin
				state <= finish;
				
			end
			end

			increment_secret_key: begin
			if (secret_key == 24'h3F_FFFF) begin
				state <= finish;
			end
			else begin
				secret_key <= secret_key + 1;
				state <= task1_go;
			end
			end

			finish: begin
					LEDR <= 10'b1;
					state <= idle;
					end
		endcase
		end
		end
	

	// control signal
	always_comb begin
		case (fsm) 
		4'b0001: begin
			wren = wren_1;
			mem_address = mem_address_1;
			mem_data = mem_data_1;
			ram_addr = 0;
			ram_data = 0;
			wren_ram = 0;
			rom_addr = 0;
		end
		
		4'b0010: begin
			wren = wren_2a;
			mem_address = mem_address_2a;
			mem_data = mem_data_2a;
			ram_addr = 0;
			ram_data = 0;
			wren_ram = 0;
			rom_addr = 0;
		end

		4'b0100: begin
			wren = wren_2b;
			mem_address = mem_address_2b;
			mem_data = mem_data_2b;
			ram_addr = ram_addr_2b;
			ram_data = ram_data_2b;
			wren_ram = wren_ram_2b;
			rom_addr = rom_addr_2b;
		end

		4'b1000: begin
			wren = 0;
			mem_address = 0;
			mem_data = 0;
			ram_addr = ram_addr_3;
			ram_data = 0;
			wren_ram = 0;
			rom_addr = 0;
		end
		
		default: begin
			wren = 0;
			mem_address = 0;
			mem_data = 0;
			ram_addr = 0;
			ram_data = 0;
			wren_ram = 0;
			rom_addr = 0;
		end
		endcase
	end           

endmodule
