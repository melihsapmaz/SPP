module control_unit(

    input clk,

    input reset,

    input go_i,

    input is_even, // from datapath, based on current mem_data[i,j]

    input i_lt,    // from datapath, based on current i (e.g., i < 16)

    input eq,      // from datapath, based on current j (e.g., j == 16)

    output reg Ld_i, Ld_j, Ld_p, Ld_r,

    output reg Sj,

    output reg done

);
 
// State definitions

localparam S0 = 3'b000;  // Idle

localparam S1 = 3'b001;  // Decide for row i / Reset j

localparam S2 = 3'b010;  // Process column j for row i / Increment i if row_done

localparam S3 = 3'b011;  // Final result / Done

localparam S4 = 3'b100;	 // Holding result 
 
reg [2:0] state, next_state;
 
// 1. State Register

always @(posedge clk) begin

    if (reset) state <= S0;

    else state <= next_state;

end
 
// 2. Next State Logic

always @(*) begin

    next_state = state; // Default: stay in current state

    case (state)

        S0: if (go_i) next_state = S1;
 
        S1: begin // i has its value for the row to be potentially processed. j will be reset.

            if (i_lt) next_state = S2;  // Ok to process row i

            else next_state = S3;       // Done with rows (e.g., i is 16 or more)

        end
 
        S2: begin // Processing element mem[i,j]

            if (eq) next_state = S1;    // End of column (j became 16). Go to S1 to decide about next i

        end
 
        S3: next_state = S4;

		S4: next_state = S4; // Stay in holding state
 
        default: next_state = S0;

    endcase

end
 
// 3. Output Logic

always @(*) begin

    // Default values

    Ld_i = 0; Ld_j = 0; Ld_p = 0; Ld_r = 0;

    Sj = 0;

    done = 0;
 
    case (state)

        S0: begin end // Idle
 
        S1: begin // Deciding for row i. Reset j for the potential new row.

            Ld_j = 1;  // Load 0 into j (since Sj=0)

            Sj = 0;

            // Ld_i is NOT asserted here. i has its value from previous increment or reset.

            // S1's next_state logic uses this i to decide.

        end
 
        S2: begin // Processing mem[i,j]

            // If j is valid (0-15 for eq based on j==16) AND data is even:
           
            Ld_p = !eq && is_even; // Assert Ld_p to multiply product by current mem_data[i,j]
            
 
            // Prepare for next j or next i:

            Ld_j = !eq;  // If j is not 16 (i.e. !eq is true), enable loading j.

            Sj = 1;      // If Ld_j active, next_j will be j+1.

                         // If eq is true (j=16), Ld_j is 0, so j is not updated by this.
 
            Ld_i = eq;   // If end of row (j just became 16, so eq is true), assert Ld_i.

                         // This will cause 'i' to increment on the next clock edge.
                         // State will transition to S1, which will then use the new 'i'.

        end
 
        S3: begin 

            Ld_r = 1;    // Load final product into result

        end

		S4: begin

            done = 1;  // Assert done signal here

        end

    endcase

end

endmodule