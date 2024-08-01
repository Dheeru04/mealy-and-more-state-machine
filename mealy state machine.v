module state_machine_mealy(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State declarations
    parameter zero = 0, one1 = 1, two1s = 2;
    
    // State registers
    reg [1:0] state, next_state;

    // State register logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= zero;
        else
            state <= next_state;
    end

    // Next state logic and output logic combined (Mealy)
    always @(state or in) begin
        case (state)
            zero: begin
                if (in)
                    next_state = one1;
                else
                    next_state = zero;
                out = 0;
            end
            one1: begin
                if (in)
                    next_state = two1s;
                else
                    next_state = zero;
                out = 0;
            end
            two1s: begin
                if (in)
                    next_state = two1s;
                else
                    next_state = zero;
                out = 1; // Output depends on state only
            end
            default: begin
                next_state = zero;
                out = 0;
            end
        endcase
    end

endmodule
module state_machine_tb();
    reg clk, reset, in;
    wire out;
    integer i;

    // Instantiate the Unit Under Test (UUT)
    // Change state_machine_mealy to state_machine_moore to test the Moore machine
    state_machine_mealy dut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // Clock generation
    initial forever #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initial values
        reset = 1'b1;
        clk = 1'b0;
        in = 0;
        #6;
        reset = 1'b0;

        // Apply a sequence of random inputs
        for (i = 0; i < 10; i = i + 1) begin 
            @(negedge clk); #1;
            in = $random;
            if (out == 1'b1)
                $display("PASS: Sequence 11 detected at i = %d", i);
        end

        #50;
        $finish;
    end
endmodule
