`ifndef __USART_TX_V__
`define __USART_TX_V__

module USART_Tx # (
	parameter CLOCKS_PER_BIT = 868, // CLOCKS_PER_BIT = Clock(Hz) / Baud Rate = 100000000 / 115200 = 868
	parameter MAX_TX_BIT_COUNT = 9,
	parameter MAX_DATA_BUFFER_INDEX = 15
	)   (
	input wire clk,
	input wire reset,
	output wire tx
	);

	reg [11:0] clk_count; // clock count
	reg [3:0] bit_count; // bit count [start bit | d0 | d1 | d2 | d3 | d4 | d5 | d6 | d7 | stop bit]
	reg [7:0] data; // data to transmit
	reg [3:0] data_buffer_index;
	reg [3:0] data_buffer_base;
	reg [7:0] data_buffer[0:MAX_DATA_BUFFER_INDEX]; // data buffer
	reg tx_bit;

	// Transmitter Process
	// at every rising edge of the clock
	always @ (posedge clk)
	begin
		if (reset == 1)
		begin
			clk_count = 0;
			bit_count = 0;
			tx_bit = 1; // set idle
			data_buffer_index = 0; // data index
		end
		else
		begin
			// transmit data until the index became the same with the base index
			if (data_buffer_index != data_buffer_base)
			begin
				if (clk_count == CLOCKS_PER_BIT)
				begin
					if (bit_count == 0)
					begin
						tx_bit = 1; // idle bit
						bit_count = 1;
						data = data_buffer[data_buffer_index];
					end
					else if (bit_count == 1)
					begin
						tx_bit = 0; // start bit
						bit_count = 2;
					end
					else if (bit_count <= MAX_TX_BIT_COUNT)
					begin
						tx_bit = data[bit_count-2]; // data bits
						bit_count = bit_count + 1;
					end
					else
					begin
						tx_bit = 1; // stop bit
						data_buffer_index = data_buffer_index + 1; // if the index exceeds its maximum, it becomes 0.
						bit_count = 0;
					end
					clk_count = 0; // reset clock count
				end

				clk_count = clk_count + 1; // increase clock count
			end
		end
	end

	assign tx = tx_bit;

endmodule

`endif /*__USART_TX_V__*/
