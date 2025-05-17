module top_module (
    input clk,
    input reset,
    input [0:0] KEY,
    output [9:0] LEDR
);

    wire [15:0] result;
    wire [15:0] mem_data, product;
	 wire [4:0] i, j ;
    wire done, is_even;

    wire go_i = KEY[0];  // or use edge detection for better accuracy

    even_mult uut (
        .clk(clk),
        .reset(reset),
        .go_i(go_i),
        .result(result),
        .done(done)
    );
	 
	 

    assign LEDR = result[9:0]; // Display lower 10 bits of result

endmodule
