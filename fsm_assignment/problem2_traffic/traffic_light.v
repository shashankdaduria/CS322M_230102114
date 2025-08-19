module traffic_light(
    input  wire clk,       // system clock (fast, e.g., 100 MHz)
    input  wire rst,       // synchronous reset (active-high)
    input  wire tick,      // 1-cycle tick pulse (e.g., 1 Hz, from tick generator)
    output reg  ns_g, ns_y, ns_r,  // North-South traffic lights
    output reg  ew_g, ew_y, ew_r   // East-West traffic lights
);

    //===============================
    // State encoding
    //===============================
    localparam S_NS_G = 2'b00;  // North-South Green
    localparam S_NS_Y = 2'b01;  // North-South Yellow
    localparam S_EW_G = 2'b10;  // East-West Green
    localparam S_EW_Y = 2'b11;  // East-West Yellow

    reg [1:0] state, next_state;   // FSM current and next state
    reg [2:0] tick_count;          // counts ticks within each state (up to 5)

    //===============================
    // State register (sequential block)
    //===============================
    always @(posedge clk) begin
        if (rst) begin
            // On reset, start with NS green and clear tick counter
            state <= S_NS_G;
            tick_count <= 0;
        end else begin
            // Normal operation: move to next state
            state <= next_state;
        end
    end

    //===============================
    // Tick counter (duration control)
    //===============================
    always @(posedge clk) begin
        if (rst) begin
            tick_count <= 0;   // reset counter
        end else if (tick) begin
            case (state)
                // Stay in NS green for 5 ticks
                S_NS_G: tick_count <= (tick_count == 4) ? 0 : tick_count + 1;
                // Stay in NS yellow for 2 ticks
                S_NS_Y: tick_count <= (tick_count == 1) ? 0 : tick_count + 1;
                // Stay in EW green for 5 ticks
                S_EW_G: tick_count <= (tick_count == 4) ? 0 : tick_count + 1;
                // Stay in EW yellow for 2 ticks
                S_EW_Y: tick_count <= (tick_count == 1) ? 0 : tick_count + 1;
            endcase
        end
    end

    //===============================
    // Next-state logic (combinational)
    //===============================
    always @(*) begin
        next_state = state;   // default: hold state
        case (state)
            // After 5 ticks in NS green → go to NS yellow
            S_NS_G: if (tick && tick_count == 4) next_state = S_NS_Y;
            // After 2 ticks in NS yellow → go to EW green
            S_NS_Y: if (tick && tick_count == 1) next_state = S_EW_G;
            // After 5 ticks in EW green → go to EW yellow
            S_EW_G: if (tick && tick_count == 4) next_state = S_EW_Y;
            // After 2 ticks in EW yellow → go back to NS green
            S_EW_Y: if (tick && tick_count == 1) next_state = S_NS_G;
        endcase
    end

    //===============================
    // Output logic (Moore machine)
    // Lights are based only on the current state
    //===============================
    always @(*) begin
        // Default all lights off
        ns_g = 0; ns_y = 0; ns_r = 0;
        ew_g = 0; ew_y = 0; ew_r = 0;

        case (state)
            // NS = Green, EW = Red
            S_NS_G: begin
                ns_g = 1; ew_r = 1;
            end
            // NS = Yellow, EW = Red
            S_NS_Y: begin
                ns_y = 1; ew_r = 1;
            end
            // EW = Green, NS = Red
            S_EW_G: begin
                ew_g = 1; ns_r = 1;
            end
            // EW = Yellow, NS = Red
            S_EW_Y: begin
                ew_y = 1; ns_r = 1;
            end
        endcase
    end

endmodule
