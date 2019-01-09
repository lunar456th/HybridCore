`ifndef __USART_RX_V__
`define __USART_RX_V__

module USART_Rx # (
	parameter CLOCKS_PER_BIT = 868, // CLOCKS_PER_BIT = Clock(Hz) / Baud Rate = 100000000 / 115200 = 868
	parameter CLOCKS_WAIT_FOR_RECEIVE = 434,
	parameter MAX_DATA_BUFFER_INDEX = 15
	)   (
	input wire clk,
	input wire reset,
	input wire rx
	);

	reg [11:0] clk_count;
	reg [3:0] bit_count;
	reg [7:0] data;
	reg [3:0] data_buffer_base;
	reg [7:0] data_buffer[0:MAX_DATA_BUFFER_INDEX]; // data buffer
	reg state;

	// Receiver Processs
	// at every rising edge of the clock
	always @ (posedge clk)
	begin
		if (reset == 1)
		begin
			clk_count = 0;
			bit_count = 0;
			data_buffer_base = 0; // base index
			state = 0;
		end
		else
		begin
			// if not receive mode and start bit is detected
			if (state == 0 && rx == 0)
			begin
				state = 1; // enter receive mode
				bit_count = 0;
				clk_count = 0;
			end
			// if receive mode
			else if (state == 1)
			begin
				if (bit_count == 0 && clk_count == CLOCKS_WAIT_FOR_RECEIVE)
				begin
					bit_count = 1;
					clk_count = 0;
				end
				else if (bit_count < 9 && clk_count == CLOCKS_PER_BIT)
				begin
					data[bit_count-1] = rx;
					bit_count = bit_count + 1;
					clk_count = 0;
				end
				// stop receiving
				else if (bit_count == 9 && clk_count == CLOCKS_PER_BIT && rx == 1)
				begin
					state = 0;
					clk_count = 0;
					bit_count = 0;

					// transmit the received data back to the host PC.
					data_buffer[data_buffer_base] = data;
					data_buffer_base = data_buffer_base + 1; // if the index exceeds its maximum, it becomes 0.
				end
				// if stop bit is not received, clear the received data
				else if (bit_count == 9 && clk_count == CLOCKS_PER_BIT && rx != 1)
				begin
					state = 0;
					clk_count = 0;
					bit_count = 0;
					data = 8'b00000000; // invalidate
				end

				clk_count = clk_count + 1;
			end
		end
	end

endmodule

`endif /*__USART_RX_V__*/
