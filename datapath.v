module datapath(
    input clk, reset,
    input Sj,
    input Ld_i, Ld_j, Ld_p, Ld_r,
    output reg [15:0] result,
    output reg is_even,
    output reg i_lt,
    output reg eq    
);


reg [15:0] mem [0:255];


 reg [4:0] i ;
 reg [4:0] j ;
 reg [15:0] product ;
 reg [15:0] mem_data ;
	 
reg [15:0] addr;
reg [4:0] next_i;
reg [4:0] next_j;

initial begin
    $readmemh("data.hex", mem); // Loads memory from the file
end

// Combinational logic block
always @(*) begin
    next_i = i + 1;
    next_j = Sj ? j + 1 : 8'd0;
    addr = i * 16 + j ;
    mem_data = mem[addr];
    is_even = ~mem_data[0];
    i_lt = (i < 8'd16);
    eq = (j == 8'd16);
end

// Sequential logic block
always @(posedge clk) begin
    if (reset) begin
        i <= 8'd0;
        j <= 8'd0;
        product <= 8'd1;
        result <= 8'd1;
    end else begin
        if (Ld_i) i <= next_i;
        if (Ld_j) j <= next_j;
        if (Ld_p) product <= product * mem_data;
        if (Ld_r) result <= product;
    end
end

endmodule
