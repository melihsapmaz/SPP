module even_mult(
    input clk, reset, go_i,
    output [15:0] result,
	 output done
);

    wire Ld_i, Ld_j , Ld_p , Ld_r ;
	 wire Sj ;
    wire i_lt, eq, is_even ;
	 wire [15:0] result_internal;

    datapath dp(
	 
        .clk(clk), .reset(reset),
        .Ld_i(Ld_i), .Ld_j(Ld_j), .Ld_p(Ld_p) , .Ld_r(Ld_r),
		  .Sj(Sj),
		  .result(result_internal) ,
        .i_lt(i_lt),
		  .is_even(is_even),
		  .eq(eq)
    );

    control_unit cu(

        .clk(clk), .reset(reset), .go_i(go_i),
        .i_lt(i_lt),
		  .is_even(is_even),
		  .eq(eq),
        .Ld_i(Ld_i), .Ld_j(Ld_j), .Ld_p(Ld_p) , .Ld_r(Ld_r),
		  .Sj(Sj),.done(done)
    );

	 
	 
    assign result = result_internal;

	
endmodule
