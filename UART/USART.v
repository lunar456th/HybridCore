module USART # (
	parameter CLOCKS_PER_BIT = 868, // baud rate : 115200, Clock : 100MHz, 10ns
	parameter CLOCKS_WAIT_FOR_RECEIVE = CLOCKS_PER_BIT / 2,
	parameter MAX_TX_BIT_COUNT = 9,
	parameter MAX_DATA_BUFFER_INDEX = 15
	)	(
	input RESET,
	input CLK,
	input RXD,
	output TXD
	);

	reg [11:0] tx_clk_count; // clock count
	reg [3:0] tx_bit_count; // bit count [start bit | d0 | d1 | d2 | d3 | d4 | d5 | d6 | d7 | stop bit]
	reg [7:0] tx_data; // data to transmit
	reg tx_bit;

	reg [11:0] rx_clk_count;
	reg [3:0] rx_bit_count;
	reg [7:0] rx_data;
	reg rx_state;

	reg [3:0] data_buffer_index;
	reg [3:0] data_buffer_base;
	reg [7:0] data_buffer[0:MAX_DATA_BUFFER_INDEX]; // data buffer

	// Transmitter Process at every rising edge of the clock
	always @ (posedge CLK)
	begin
		if (RESET == 1)
		begin
			tx_clk_count = 0;
			tx_bit_count = 0;
			tx_bit = 1; // set idle
			data_buffer_index = 0; // data index
		end
		else begin
			// transmit data until the index became the same with the base index
			if (data_buffer_index != data_buffer_base)
			begin
				if (tx_clk_count == CLOCKS_PER_BIT)
				begin
					if (tx_bit_count == 0)
					begin
						tx_bit = 1; // idle bit
						tx_bit_count = 1;
						tx_data = data_buffer[data_buffer_index];
					end
					else if (tx_bit_count == 1)
					begin
						tx_bit = 0; // start bit
						tx_bit_count = 2;
					end
					else if (tx_bit_count <= MAX_TX_BIT_COUNT)
					begin
						tx_bit = tx_data[tx_bit_count-2]; // data bits
						tx_bit_count = tx_bit_count + 1;
					end
					else
					begin
						tx_bit = 1; // stop bit
						data_buffer_index = data_buffer_index + 1; // if the index exceeds its maximum, it becomes 0.
						tx_bit_count = 0;
					end
					tx_clk_count = 0; // reset clock count
				end

				tx_clk_count = tx_clk_count + 1; // increase clock count
			end
		end
	end

	// Receiver Processs at every rising edge of the clock
	always @ (posedge CLK)
	begin
		if (RESET == 1)
		begin
			rx_clk_count = 0;
			rx_bit_count = 0;
			data_buffer_base = 0; // base index

			rx_state = 0;
		end
		else
		begin
			// if not receive mode and start bit is detected
			if (rx_state == 0 && RXD == 0)
			begin
				rx_state = 1; // enter receive mode
				rx_bit_count = 0;
				rx_clk_count = 0;
			end
			// if receive mode
			else if (rx_state == 1)
			begin
				if (rx_bit_count == 0 && rx_clk_count == CLOCKS_WAIT_FOR_RECEIVE)
				begin
					rx_bit_count = 1;
					rx_clk_count = 0;
				end
				else if (rx_bit_count < 9 && rx_clk_count == CLOCKS_PER_BIT)
				begin
					rx_data[rx_bit_count-1] = RXD;
					rx_bit_count = rx_bit_count + 1;
					rx_clk_count = 0;
				end
				// stop receiving
				else if (rx_bit_count == 9 && rx_clk_count == CLOCKS_PER_BIT && RXD == 1)
				begin
					rx_state = 0;
					rx_clk_count = 0;
					rx_bit_count = 0;

					// transmit the received data back to the host PC.
					data_buffer[data_buffer_base] = rx_data;
					data_buffer_base = data_buffer_base + 1; // if the index exceeds its maximum, it becomes 0.
				end
				// if stop bit is not received, clear the received data
				else if (rx_bit_count == 9 && rx_clk_count == CLOCKS_PER_BIT && RXD != 1)
				begin
					rx_state = 0;
					rx_clk_count = 0;
					rx_bit_count = 0;
					rx_data = 8'b00000000; // invalidate
				end

				rx_clk_count = rx_clk_count + 1;
			end
		end

	end

	assign TXD = tx_bit;

endmodule
