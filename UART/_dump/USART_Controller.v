`ifndef __USART_CONTROLLER_V__
`define __USART_CONTROLLER_V__

`include "USART_Tx.v"
`include "USART_Rx.v"

module USART_Controller # (
	parameter CLOCKS_PER_BIT = 868, // CLOCKS_PER_BIT = Clock(Hz) / Baud Rate = 100000000 / 115200 = 868
	parameter CLOCKS_WAIT_FOR_RECEIVE = 434,
	parameter MAX_TX_BIT_COUNT = 9,
	parameter MAX_DATA_BUFFER_INDEX = 15
	)	(
	input wire clk,
	input wire reset,
	output wire tx,
	input wire rx
	);
	
	wire [7:0] data[0:MAX_DATA_BUFFER_INDEX];

	USART_Tx # (
		.CLOCKS_PER_BIT(CLOCKS_PER_BIT),
		.MAX_TX_BIT_COUNT(MAX_TX_BIT_COUNT),
		.MAX_DATA_BUFFER_INDEX(MAX_DATA_BUFFER_INDEX)
	) _USART_Tx (
		.clk(clk),
		.reset(reset),
		.tx(tx),
		.data(data)
	);

	USART_Rx # (
		.CLOCKS_PER_BIT(CLOCKS_PER_BIT),
		.CLOCKS_WAIT_FOR_RECEIVE(CLOCKS_WAIT_FOR_RECEIVE),
		.MAX_DATA_BUFFER_INDEX(MAX_DATA_BUFFER_INDEX)
	) _USART_Rx (
		.clk(clk),
		.reset(reset),
		.rx(rx),
		.data(data)
	);

endmodule

`endif /*__USART_CONTROLLER_V__*/
