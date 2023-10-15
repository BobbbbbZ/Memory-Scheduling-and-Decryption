module task3(input clk,
            input sig_start,
            input [7:0] data_in,
            output task3_done,
            output task3_continue,
            output [4:0] task3_addr
            );

logic [5:0] state;
logic [4:0] i;

parameter idle                  = 6'b000000;
parameter set_addr_1            = 6'b001100;
parameter set_addr_2            = 6'b010000;
parameter checkrange            = 6'b011100;
parameter increment_i           = 6'b100000;
parameter done                  = 6'b000010;
parameter continue3             = 6'b000011;

assign task3_done = state[1];// Done signal
assign task3_continue = state[0]; // Continue signal
assign task3_addr = i; // Address output

always_ff @(posedge clk) begin
    case(state)

    idle: if (sig_start) begin
            state <= set_addr_1;
            i <= 0;
    end

    set_addr_1: state <= set_addr_2;
    set_addr_2: state <= checkrange;

    checkrange: if ((data_in >= 97 && data_in <= 122)||(data_in == 32)) state <= increment_i;
                else state <= continue3;

    continue3: state <= idle;

    increment_i: if (i == 5'd31) state <= done;
                else begin
                    i <= i + 1;
                    state <= set_addr_1;
                end

    done: state <= idle;

    default: state <= idle;

    endcase
end


endmodule