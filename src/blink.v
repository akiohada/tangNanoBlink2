module SHIFT_RESISTER (
  input clock,
  // input buttonStop,
  // input clockInput,
  // input dataInput,
  output reg [3:0] digitPinOutput,
  output reg [7:0] segmentPinsOutput
  // segmentPinsOutput = 8'b00000001;
  // DP         1000_0000
  // MID MID    0100_0000
  // RIGHT LOW  0010_0000
  // MID BTM    0001_0000
  // LEFT LOW   0000_1000
  // LEFT HIGH  0000_1000
  // MID TOP    0000_0010
  // RIGHT HIGH 0000_0001
  // 0     = 8'b0011_1111
  // 1     = 8'b0010_0001
  // 2     = 8'b0101_1011
  // 3     = 8'b0111_0011
  // 4     = 8'b0110_0101
  // 5     = 8'b0111_0110
  // 6     = 8'b0111_1110
  // 7     = 8'b0010_0011
  // 8     = 8'b0111_1111
  // 9     = 8'b0111_0111
  // -     = 8'b0100_0000
  // .     = 8'b1000_0000
);

  reg [23:0] counter;
  reg [23:0] counter2;
  integer i;

  always @(posedge clock) begin
    if (counter < 24'd100_001) // 24_000_000 = 1sec
      counter <= counter + 1;
    else
      counter <= 24'd1;
  end

  always @(posedge clock) begin
    if (counter == 24'd100_001) begin
      if (counter2 < 24'd20)
        counter2 <= counter2 + 1;
      else
        counter2 <= 24'd1;
    end
  end

  reg [7:0] digit0;
  reg [7:0] digit1;
  reg [7:0] digit2;
  reg [7:0] digit3;

// くるくる回るバージョン
//  always @(posedge clock) begin
//    if (counter2 == 0) begin
//      digit0 <= 8'b0100_0000;
//      digit1 <= 8'b0100_0000;
//      digit2 <= 8'b0100_0000;
//      digit3 <= 8'b0100_0000;
//    end
//    else if (counter2 == 24'd20) begin
//      digit0[7:0] <= {digit0[6:0], digit0[7]};
//      digit1[7:0] <= {digit1[6:0], digit1[7]};
//      digit2[7:0] <= {digit2[6:0], digit2[7]};
//      digit3[7:0] <= {digit3[6:0], digit3[7]};
//    end
//    else begin
//      digit0 <= digit0;
//      digit1 <= digit1;
//      digit2 <= digit2;
//      digit3 <= digit3;
//    end
//  end

// 固定で1234表示
//  always @(posedge clock) begin
//    digit0 <= 8'b0010_0001;
//    digit1 <= 8'b0101_1011;
//    digit2 <= 8'b0111_0011;
//    digit3 <= 8'b0110_0101;
//  end

// 1234でローテーション
always @(posedge clock) begin
  if (counter2 == 0) begin
    digit0 <= 8'b0010_0001;
    digit1 <= 8'b0101_1011;
    digit2 <= 8'b0111_0011;
    digit3 <= 8'b0110_0101;
  end
  else if (counter2 == 24'd20) begin
    digit0 <= digit1;
    digit1 <= digit2;
    digit2 <= digit3;
    digit3 <= digit0;
  end
  else begin
    digit0 <= digit0;
    digit1 <= digit1;
    digit2 <= digit2;
    digit3 <= digit3;
  end
end

  always @(posedge clock) begin
    if (counter == 24'd25_001) begin // 約1msごとに桁を切り替える
      digitPinOutput <= 4'b1110;
      for (i = 0;i < 8;i = i + 1) begin // 各segに値をセット
        segmentPinsOutput[i] <= digit0[i];
      end
    end
    else if (counter == 24'd50_001) begin
      digitPinOutput <= 4'b1101;
      for (i = 0;i < 8;i = i + 1) begin
        segmentPinsOutput[i] <= digit1[i];
      end
    end
    else if (counter == 24'd75_001) begin
      digitPinOutput <= 4'b1011;
      for (i = 0;i < 8;i = i + 1) begin
        segmentPinsOutput[i] <= digit2[i];
      end
    end
    else if (counter == 24'd100_001) begin
      digitPinOutput <= 4'b0111;
      for (i = 0;i < 8;i = i + 1) begin
        segmentPinsOutput[i] <= digit3[i];
      end
    end
  end

endmodule
