module FourDigitLedController(
  // DECLARATION: 入力
  input clock, // Loc 35 | Pull UP
  input serialClockIn, // Loc 19 | Pull NONE ※信号はプルダウン
  input serialDataIn, // Loc 20 | Pull NONE ※信号はプルダウン

  // DECLARATION: 出力
  output serialClockLedOutR, // Loc 18 | Pull NONE
  output serialClockLedOutB, // Loc 17 | Pull NONE
  output serialClockLedOutG, // Loc 16 | Pull NONE
  output reg [3:0] digitalOutputPins,// これはレジスタなの？？
    // 0: Loc 21 | Pull NONE
    // 1: Loc 22 | Pull NONE
    // 2: Loc 23 | Pull NONE
    // 3: Loc 24 | Pull NONE
  output reg [7:0] segmentOutputPins
    // 0: Loc 38 | Pull NONE
    // 1: Loc 39 | Pull NONE
    // 2: Loc 40 | Pull NONE
    // 3: Loc 41 | Pull NONE
    // 4: Loc 42 | Pull NONE
    // 5: Loc 43 | Pull NONE
    // 6: Loc 44 | Pull NONE
    // 7: Loc 45 | Pull NONE
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

  // DECLARATION: 各種カウンター
  reg [23:0] clockCounter = 24'd0; // 7セグLED制御用
  reg [3:0] serialClockCounter = 4'd0; // シリアル入力制御用
  
  // シリアル入力のLEDモニター
  reg [2:0] serialClockLed = 3'b111;
  assign serialClockLedOutR = serialClockLed[0]; // シリアルデータ入力8回目ごとに光る
  assign serialClockLedOutB = serialClockLed[1]; // シリアルクロック入力信号で光る
  assign serialClockLedOutG = serialClockLed[2]; // シリアルデータ入力ごとに光る
  always @(serialClockIn) begin
    if(serialClockCounter == 4'd0)
      serialClockLed[0] <= 0; // 光る
    else
      serialClockLed[0] <= 1; // 消える
  end
  always @(serialClockIn) begin
    if(serialClockIn == 1)
      serialClockLed[1] <= 0; // 光る
    else if(serialClockIn == 0)
      serialClockLed[1] <= 1; // 消える
  end
  always @(serialClockIn) begin
    if(serialDataIn == 1)
      serialClockLed[2] <= 0; // 光る
    else if(serialDataIn == 0)
      serialClockLed[2] <= 1; // 消える
  end

  // DECLARATION: レジスター
  reg [9:0] serialReg = 10'b100_0111_1111; // 入力信号
  reg [7:0] digit0 = 8'b0010_0001; //各桁
  reg [7:0] digit1 = 8'b0101_1011;
  reg [7:0] digit2 = 8'b0111_0011;
  reg [7:0] digit3 = 8'b0110_0101;
 
  // カウント処理
  always @(posedge clock) begin
    if (clockCounter < 24'd100_000) // 24_000_000 = 1sec なので 1/240 sec周期
      clockCounter <= clockCounter + 1;
    else
      clockCounter <= 24'd0;
  end

  // シリアル入力
  always @(posedge serialClockIn) begin
    if(serialClockCounter < 4'd9) begin
      serialClockCounter <= serialClockCounter + 1;
      serialReg[0] <= serialDataIn;
      serialReg[1] <= serialReg[0];
      serialReg[2] <= serialReg[1];
      serialReg[3] <= serialReg[2];
      serialReg[4] <= serialReg[3];
      serialReg[5] <= serialReg[4];
      serialReg[6] <= serialReg[5];
      serialReg[7] <= serialReg[6];
      serialReg[8] <= serialReg[7];
      serialReg[9] <= serialReg[8];
    end
    else begin
      serialClockCounter <= 0;
      serialReg[0] <= serialDataIn;
      serialReg[1] <= serialReg[0];
      serialReg[2] <= serialReg[1];
      serialReg[3] <= serialReg[2];
      serialReg[4] <= serialReg[3];
      serialReg[5] <= serialReg[4];
      serialReg[6] <= serialReg[5];
      serialReg[7] <= serialReg[6];
      serialReg[8] <= serialReg[7];
      serialReg[9] <= serialReg[8];
    end
  end

  // 桁ごとにセットする
  always @(negedge serialClockIn) begin
    if (serialClockCounter == 4'd0) begin
      if(serialReg[9:8] == 2'b00) begin
        digit0[7] <= serialReg[7];
        digit0[6] <= serialReg[6];
        digit0[5] <= serialReg[5];
        digit0[4] <= serialReg[4];
        digit0[3] <= serialReg[3];
        digit0[2] <= serialReg[2];
        digit0[1] <= serialReg[1];
        digit0[0] <= serialReg[0];
      end
      else if(serialReg[9:8] == 2'b01) begin
        digit1[7] <= serialReg[7];
        digit1[6] <= serialReg[6];
        digit1[5] <= serialReg[5];
        digit1[4] <= serialReg[4];
        digit1[3] <= serialReg[3];
        digit1[2] <= serialReg[2];
        digit1[1] <= serialReg[1];
        digit1[0] <= serialReg[0];
      end
      else if(serialReg[9:8] == 2'b10) begin
        digit2[7] <= serialReg[7];
        digit2[6] <= serialReg[6];
        digit2[5] <= serialReg[5];
        digit2[4] <= serialReg[4];
        digit2[3] <= serialReg[3];
        digit2[2] <= serialReg[2];
        digit2[1] <= serialReg[1];
        digit2[0] <= serialReg[0];
      end
      else if(serialReg[9:8] == 2'b11) begin
        digit3[7] <= serialReg[7];
        digit3[6] <= serialReg[6];
        digit3[5] <= serialReg[5];
        digit3[4] <= serialReg[4];
        digit3[3] <= serialReg[3];
        digit3[2] <= serialReg[2];
        digit3[1] <= serialReg[1];
        digit3[0] <= serialReg[0];
      end
    end
  end

  // 表示main処理
  // digitalOutputPinsで選ばれた桁に、レジスタdigit0〜3までの値を順番に出力する
  always @(posedge clock) begin
    if (clockCounter == 24'd24_000) begin // 約1msごとに桁を切り替える1桁目
      digitalOutputPins <= 4'b1110;
      segmentOutputPins[0] <= digit0[0];
      segmentOutputPins[1] <= digit0[1];
      segmentOutputPins[2] <= digit0[2];
      segmentOutputPins[3] <= digit0[3];
      segmentOutputPins[4] <= digit0[4];
      segmentOutputPins[5] <= digit0[5];
      segmentOutputPins[6] <= digit0[6];
      segmentOutputPins[7] <= digit0[7];
    end
    else if (clockCounter == 24'd48_000) begin // 約1msごとに桁を切り替える2桁目
      digitalOutputPins <= 4'b1101;
      segmentOutputPins[0] <= digit1[0];
      segmentOutputPins[1] <= digit1[1];
      segmentOutputPins[2] <= digit1[2];
      segmentOutputPins[3] <= digit1[3];
      segmentOutputPins[4] <= digit1[4];
      segmentOutputPins[5] <= digit1[5];
      segmentOutputPins[6] <= digit1[6];
      segmentOutputPins[7] <= digit1[7];
    end
    else if (clockCounter == 24'd72_000) begin // 約1msごとに桁を切り替える3桁目
      digitalOutputPins <= 4'b1011;
      segmentOutputPins[0] <= digit2[0];
      segmentOutputPins[1] <= digit2[1];
      segmentOutputPins[2] <= digit2[2];
      segmentOutputPins[3] <= digit2[3];
      segmentOutputPins[4] <= digit2[4];
      segmentOutputPins[5] <= digit2[5];
      segmentOutputPins[6] <= digit2[6];
      segmentOutputPins[7] <= digit2[7];
    end
    else if (clockCounter == 24'd96_000) begin // 約1msごとに桁を切り替える4桁目
      digitalOutputPins <= 4'b0111;
      segmentOutputPins[0] <= digit3[0];
      segmentOutputPins[1] <= digit3[1];
      segmentOutputPins[2] <= digit3[2];
      segmentOutputPins[3] <= digit3[3];
      segmentOutputPins[4] <= digit3[4];
      segmentOutputPins[5] <= digit3[5];
      segmentOutputPins[6] <= digit3[6];
      segmentOutputPins[7] <= digit3[7];
    end
  end

endmodule
