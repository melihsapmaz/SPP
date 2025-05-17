module testbench;

// Testbench signals
reg clk, reset, go_i;
wire [15:0] result ;
integer fd;
integer cycle_count = 0;


// Instantiate the top-level module
even_mult uut (
    .clk(clk), 
    .reset(reset), 
    .go_i(go_i), 
    .result(result),
    .done(done)
);

// Clock generation
always begin
    #10 clk = ~clk; // 10ns clock period
end

// Cycle counter
always @(posedge clk) begin
    if (!reset) cycle_count <= cycle_count + 1;
end

// Test sequence
initial begin
    // Initialize signals
    clk = 0;
    reset = 0;
    go_i = 0;
    
    // Open results file
    fd = $fopen("simulation_results.txt", "w");
    if (!fd) begin
        $display("Error opening file!");
        $finish;
    end
    
    // Write header
    $display("Starting simulation...");
    
    // Reset sequence
    reset = 1;
    #20 reset = 0;
    
    // Start processing
    go_i = 1;
    #10 go_i = 0;
    
    // Monitor signals every clock cycle
    forever begin
        @(posedge clk);
        $fdisplay(fd, "%4d | %d", 
                 cycle_count , result);
        
        // Exit when done (assuming your design has a done signal)
        // Exit when done is high
    if (done) begin
        $fdisplay(fd, "\nFinal result: %d", result);
        $fclose(fd);
		  $display("\nFinal result: %d", result);
        $display("Simulation complete. Results written to simulation_results.txt");
        $finish;
    end
        
 end
    
end

endmodule

