module task1 (input logic clk, 
			input logic sig_start,
			output logic [7:0] mem_address, 
			output logic [7:0] mem_data,
			output logic wren, 
			output logic t_done);

	logic [7:0] i;
	logic [1:0] state;
	parameter idle 			= 2'b00;
	parameter write			= 2'b10;
	parameter finish		= 2'b01;


	assign mem_address = i; // Assign the value of 'i' to mem_address
	assign mem_data = i; //Assign the value of 'i' to mem_data
	assign t_done = state[0]; // Finished signal
	assign wren = state[1];  // Write enable signal

	always_ff @(posedge clk) begin
		case (state)
			idle: begin
				if (sig_start) begin
					i <= 0;			// rest i to 0
					state <= write; // Transition to the write state
				end
			end

			write: if (i == 255) state <= finish; // Check if 'i' has reached its maximum value
				else i <= i + 1;	//Increment 'i' by 1

			finish: state <= idle; // Transition back to the idle state

		endcase
		end

endmodule