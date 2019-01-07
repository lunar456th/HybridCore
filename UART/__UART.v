`ifndef __UART_V__
`define __UART_V__

// Clock freq : 100MHz 기준
// Baud rate  : 115200 bps
// Data bit   : 8 bits
// Parity bit : no parity
// stop bit   : 1 bit
// 이것도 동적으로 작성은 가능할 듯.

// UART Controller
module example_top (
	input wire clk,
	output wire tx,
	input wire rx
	);

	reg write_en;
	reg write_busy;
	reg read_clear;
	reg read_complete;

	reg [7:0] data_in;
	reg [7:0] data_out;

	UART _UART(
		.clk(clk),
		.tx(tx),
		.rx(rx),
		.data_in(data_in),
		.data_out(data_out),
		.write_en(write_en),
		.write_busy(write_busy),
		.read_clear(read_clear),
		.read_complete(read_complete)
	);

	initial
	begin
		write_en <= 1'b0;
		write_busy <= 1'b0;
		read_clear <= 1'b0;
		read_complete <= 1'b0;
		data_in <= 8'b0;
		data_out <= '8'b0;
	end

	always @ (posedge clk)
	begin
		// Do something...
	end

endmodule

// UART Interface
module UART (
	input wire clk, // System clock: 100MHz
	output wire tx, // Tx line
	input wire rx, // Rx line
	input wire [7:0] data_in, // Data in from Rx
	output wire [7:0] data_out, // Data out to Tx
	input wire write_en,
	output wire write_busy,
	input wire read_clear,
	output wire read_complete
	);

	wire rxclk_en;
	wire txclk_en;

	// Hacky baud rate generator to divide a 100MHz clock into a 115200 baud
	// rx/tx pair where the rx clcken oversamples by 16x.
	// 이렇게 해도 합성이 되나?
	integer clk_freq = 100000000;
	integer baudrate = 115200;
	integer oversamples = 16;

	parameter RX_ACC_MAX = clk_freq / (baudrate * oversamples); // 54.253
	parameter TX_ACC_MAX = clk_freq / baudrate; // 868.056
	parameter RX_ACC_WIDTH = $clog2(RX_ACC_MAX); // 5.762 = 6
	parameter TX_ACC_WIDTH = $clog2(TX_ACC_MAX); // 9.762 = 10

	reg [RX_ACC_WIDTH - 1:0] rx_acc = 0;
	reg [TX_ACC_WIDTH - 1:0] tx_acc = 0;

	assign rxclk_en = (rx_acc == 0);
	assign txclk_en = (tx_acc == 0);

	always @ (posedge clk)
	begin
		if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0])
		begin
			rx_acc <= 0;
		end
		else
		begin
			rx_acc <= rx_acc + 1;
		end
	end

	always @ (posedge clk)
	begin
		if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
		begin
			tx_acc <= 0;
		end
		else
		begin
			tx_acc <= tx_acc + 1;
		end
	end

	// Tx
	initial
	begin
		 tx <= 1'b1;
	end

	parameter STATE_IDLE	= 2'b00;
	parameter STATE_START	= 2'b01;
	parameter STATE_DATA	= 2'b10;
	parameter STATE_STOP	= 2'b11;

	reg [7:0] data = 8'h00;
	reg [2:0] index = 3'h0;
	reg [1:0] state = STATE_IDLE;

	always @ (posedge clk)
	begin
		case (state)
			STATE_IDLE:
			begin
				if (write_en)
				begin
					state <= STATE_START;
					data <= data_in;
					index <= 3'h0;
				end
			end

			STATE_START:
			begin
				if (txclk_en)
				begin
					tx <= 1'b0;
					state <= STATE_DATA;
				end
			end

			STATE_DATA:
			begin
				if (txclk_en)
				begin
					if (index == 3'h7)
						state <= STATE_STOP;
					else
						index <= index + 3'h1;
					tx <= data[index];
				end
			end

			STATE_STOP:
			begin
				if (txclk_en)
				begin
					tx <= 1'b1;
					state <= STATE_IDLE;
				end
			end

			default:
			begin
				tx <= 1'b1;
				state <= STATE_IDLE;
			end
		endcase
	end

	assign write_busy = (state != STATE_IDLE);

	// Rx
	initial begin
		read_complete <= 0;
		data <= 8'b0;
	end

	parameter RX_STATE_START = 2'b00;
	parameter RX_STATE_DATA = 2'b01;
	parameter RX_STATE_STOP = 2'b10;

	reg [1:0] state = RX_STATE_START;
	reg [3:0] sample = 0;
	reg [3:0] index = 0;
	reg [7:0] scratch = 8'b0;

	always @(posedge clk)
	begin
		if (read_clear)
		begin
			read_complete <= 0;
		end

		if (rxclk_en)
		begin
			case (state)
				RX_STATE_START:
				begin
					/*
					* Start counting from the first low sample, once we've
					* sampled a full bit, start collecting data bits.
					*/
					if (!rx || sample != 0)
					begin
						sample <= sample + 4'b1;
					end

					if (sample == 15)
					begin
						state <= RX_STATE_DATA;
						index <= 0;
						sample <= 0;
						scratch <= 0;
					end
				end

				RX_STATE_DATA:
				begin
					sample <= sample + 4'b1;
					if (sample == 4'h8)
					begin
						scratch[index[2:0]] <= rx;
						index <= index + 4'b1;
					end
					if (index == 8 && sample == 15)
					begin
						state <= RX_STATE_STOP;
					end
				end

				RX_STATE_STOP:
				begin
					/*
					 * Our baud clock may not be running at exactly the same rate as the transmitter.
					 * If we thing that we're at least half way into the stop bit,
					 * allow transition into handling the next start bit.
					 */
					if (sample == 15 || (sample >= 8 && !rx))
					begin
						state <= RX_STATE_START;
						data <= scratch;
						read_complete <= 1'b1;
						sample <= 0;
					end
					else
					begin
						sample <= sample + 4'b1;
					end
				end

				default:
				begin
					state <= RX_STATE_START;
				end
			endcase
		end
	end
endmodule

`endif /*__UART_V__*/
