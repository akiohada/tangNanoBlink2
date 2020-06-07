module blink (
    input wire clock,
    input wire resetn,
    output wire led_r,
    output wire led_g,
    output wire led_b
);

reg [23:0] divider;
reg [2:0] led_out;
localparam [23:0] DIVIDER_UPPER = 24'd12_000_000 - 24'd1;

assign led_r = !led_out[0];
assign led_g = !led_out[1];
assign led_b = !led_out[2];

always @(posedge clock) begin
    if( !resetn ) begin
        divider <= 0;
        led_out <= 0;
    end
    else begin
        divider <= divider == DIVIDER_UPPER ? 0 : divider + 1;
        led_out <= divider == DIVIDER_UPPER ? led_out + 1 : led_out;
    end
end 

endmodule

