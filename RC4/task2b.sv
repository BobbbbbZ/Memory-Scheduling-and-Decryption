module task2b (
                input clk,
                input sig_start,
                input logic [7:0] rom_data,
                input logic [7:0] mem_out,
                output wren_ram,
                output t_done,
                output wren,
                output logic [4:0] rom_addr,
                output logic [4:0] ram_addr,
                output logic [7:0] ram_data,
                output logic [7:0] mem_address,
                output logic [7:0] mem_data);

  logic [11:0] state;
  logic si_en, sj_en, f_en;
  logic [7:0] i, j, k, si, sj, f;

  parameter idle              = 12'b000000_000000;
  parameter increment_i       = 12'b000001_000000;
  parameter geti_1            = 12'b000010_000000;
  parameter geti_2            = 12'b000000_001000;
  parameter geti_3            = 12'b000001_001000;
  parameter getj_1            = 12'b000011_000000;
  parameter getj_2            = 12'b000100_000000;
  parameter getj_3            = 12'b000000_010000;
  parameter getj_4            = 12'b000001_010000;
  parameter si2sj             = 12'b000101_000000;
  parameter siwrite2sj        = 12'b000000_000010;
  parameter siwrite2sj_wait   = 12'b000001_000010;
  parameter sj2si             = 12'b000110_000000;
  parameter sjwrite2si        = 12'b000010_000010;
  parameter sjwrite2si_wait   = 12'b000011_000010;
  parameter getf_1            = 12'b000111_000000;
  parameter getf_2            = 12'b000000_100000;
  parameter getf_3            = 12'b000001_100000;
  parameter getk_1            = 12'b001000_000000;
  parameter getk_2            = 12'b001001_000000;
  parameter xor_f             = 12'b001010_000000;
  parameter writek            = 12'b000000_000100;
  parameter increment_k       = 12'b001100_000000;
  parameter done              = 12'b000000_000001;

  assign t_done = state[0]; // Finished signal
  assign wren      = state[1]; // Write enable 
  assign wren_ram   = state[2];   // write to ram enable
  assign si_en   = state[3]; // Enable signal for si register
  assign sj_en   = state[4]; // Enable signal for sj register
  assign f_en     = state[5]; // Enable signal for f register


parameter message_length = 8'd32;

always_ff @(posedge clk) begin
    case (state)
      idle: begin
        if (sig_start) begin
          state <= increment_i;
          i <= 0;
          j <= 0;
          k <= 0;
        end
      end

      increment_i: begin
        i <= i + 1;
        ram_addr <= k;
        rom_addr <= k;
        state <= geti_1;
      end

      geti_1: begin
        mem_address <= i;
        state <= geti_2;
      end

      geti_2: state <= geti_3;
      
      geti_3: state <= getj_1;
      
      getj_1: begin
        j <= j + si;
        state <= getj_2;
      end

      getj_2: begin
        mem_address <= j;
        state <= getj_3;
      end

      getj_3: state <= getj_4;

      getj_4: state <= si2sj;

      //swap start
      si2sj: begin
        mem_address <= j;
        mem_data <= si;
        state <= siwrite2sj;
      end

      siwrite2sj: state <= siwrite2sj_wait;

      siwrite2sj_wait: state <= sj2si;

      sj2si: begin
        mem_address <= i;
        mem_data <= sj;
        state <= sjwrite2si;
      end

      sjwrite2si: state <= sjwrite2si_wait;

      sjwrite2si_wait: state <= getf_1;
      //swap end

      getf_1: begin
        mem_address <= si + sj;
        state <= getf_2;
      end

      getf_2: state <= getf_3;

      getf_3: state <= getk_1;

      getk_1: state <= getk_2;

      getk_2: state <= xor_f;

      xor_f: begin
        ram_data <= f ^ rom_data;
        state <= writek;
      end

      writek: state <= increment_k;

      increment_k: begin
        if (k == (message_length - 8'b1)) state <= done;
        else begin
          k <= k + 1;
          state <= increment_i;
        end
      end        

      done: state <= idle;
    endcase
  end

always_ff @(posedge clk) begin
    if (si_en) si <= mem_out;
    if (sj_en) sj <= mem_out;
    if (f_en) f <= mem_out;
  end
endmodule