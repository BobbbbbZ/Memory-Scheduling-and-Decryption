module task2a(input logic clk, input logic sig_start,
            input [23:0] key, input [7:0] data_in,
            output logic t_done, output logic t_write,
            output logic [7:0] mem_address, output logic [7:0] mem_data);

        logic [6:0] state;
        logic [7:0] i, j, data_i, data_j;
        logic t_getend;

        parameter keylength = 3;

        logic [7:0] secret_key_byte[0:2];
        assign secret_key_byte[0] = key[23:16]; // Extract bits 23-16 from key and assign to secret_key_byte[0]
	    assign secret_key_byte[1] = key[15:8]; // Extract bits 15-8 from key and assign to secret_key_byte[1]
	    assign secret_key_byte[2] = key[7:0]; // Extract bits 7-0 from key and assign to secret_key_byte[2]

        parameter idle              = 7'b0000000;
        parameter initial_value     = 7'b0000100;
        parameter checki            = 7'b0001000;
        parameter geti_1            = 7'b0001100;
        parameter getj              = 7'b0010000;
        parameter getj_1            = 7'b0010100;
        parameter swap              = 7'b1010100;
        parameter sj2si             = 7'b0101000;
        parameter sjwrite2si        = 7'b0000010; 
        parameter si2sj             = 7'b0101100;
        parameter siwrite2sj        = 7'b0000110;
        parameter increment         = 7'b0110000;
        parameter finish            = 7'b0000001;
        parameter geti_2            = 7'b0111000;
        parameter geti_3            = 7'b0111100;
        parameter geti_4            = 7'b1111100;
        parameter getj_2            = 7'b1000000;
        parameter getj_3            = 7'b1000100;
        parameter getj_4            = 7'b1001000;

        assign t_done = state[0];// Finished signal
	    assign t_write = state[1]; // Write enable signal


        always_ff @(posedge clk) begin
            
            case (state)

                idle: if (sig_start) state <= initial_value;
                        else state <= idle;

                initial_value: state <= checki;

                checki: if (t_getend) state <= finish;
                        else state <= geti_1;

                geti_1: state <= geti_2;
                geti_2: state <= geti_3;
                geti_3: state <= geti_4;
                geti_4: state <= getj;

                getj: state <= getj_1;

                getj_1: state <= getj_2;
                getj_2: state <= getj_3;
                getj_3: state <= getj_4;
                getj_4: state <= swap;

                swap: state <= si2sj;

                si2sj: state <= siwrite2sj;
                siwrite2sj: state <= sj2si;
                sj2si: state <= sjwrite2si;
                sjwrite2si: state <= increment; 

                increment: state <= checki;

                finish: state <= idle;

                default: state <= idle;

            endcase

        end


        always_ff @(posedge clk) begin
            case (state)

            initial_value: begin
                i <= 8'd0;
                j <= 8'd0;
                data_i <= data_i; 
				data_j <= data_j; 
                mem_address <= mem_address;
                mem_data <= mem_data;
                t_getend <= 1'b0;
            end

            geti_1: begin
                i <= i; 
                j <= j; 
                data_i <= data_i;
                data_j <= data_j;
                mem_address <= i;
                mem_data <= mem_data;
                if (i == 8'hFF) t_getend <= 1'b1;
                else t_getend <= 1'b0;
           end

            geti_4: begin
                i <= i; 
                j <= j;
                data_i <= data_in;
                data_j <= data_j;
                mem_address <= mem_address;
                mem_data <= mem_data; 
                t_getend <= t_getend;
           end

            getj: begin
                i <= i; 
                j <= (j + data_i + secret_key_byte[i%keylength]);
                data_i <= data_i; 
                data_j <= data_j;
                mem_address <= mem_address;
                mem_data <= mem_data; 
                t_getend <= t_getend;
            end

            getj_1: begin
                i <= i; 
                j <= j;
                data_i <= data_i; 
                data_j <= data_j;
                mem_address <= j;
                mem_data <= mem_data; 
                t_getend <= t_getend;
            end

           getj_4: begin
                i <= i; 
			    j <= j;
			    data_i <= data_i; 
                data_j <= data_in;
                mem_address <= mem_address;
                mem_data <= mem_data; 
                t_getend <= t_getend;
            end

            si2sj: begin
                i <= i; 
			    j <= j;
			    data_i <= data_i; 
			    data_j <= data_j; 
                mem_address <= j;
                mem_data <= data_i;
                t_getend <= t_getend;
            end

            sj2si: begin
                i <= i; 
			    j <= j;
			    data_i <= data_i; 
			    data_j <= data_j; 
                mem_address <= i;
                mem_data <= data_j;
                t_getend <= t_getend;
            end

            increment: begin
                i <= i + 8'd1;
                j <= j; 
                data_i <= data_i; 
                data_j <= data_j; 
                mem_address <= mem_address;
                mem_data <= mem_data; 
                t_getend <= t_getend;
            end

            default: begin 
                i <= i; 
                j <= j;
                data_i <= data_i; 
                data_j <= data_j; 
                mem_address <= mem_address;
                mem_data <= mem_data; 
                t_getend <= t_getend;
			end 

            endcase
        end 
endmodule