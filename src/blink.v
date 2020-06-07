module SHIFT_RESISTER (
  // DECLARATION: クロック
  input clock,
    // Loc 35 | Pull UP

  // DECLARATION: シリアル信号入力
  // input serialClockIn,
  // input serialDataIn,
  output serialClockLedOut,

  // DECLARATION: 7セグ4桁LED表示用
  output reg [3:0] digitalOutputPins,
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
  reg [23:0] clockCounter = 0;
  // reg [23:0] clockCounter2 = 0;
  reg [3:0] segmentCounter = 0;
  reg [2:0] digitCounter = 0;
  reg [1:0] serialClockLed = 0;
  wire serialClockLedOut = serialClockLed;
  integer i = 0;
  integer j = 0;

  // カウントUP
  always @(posedge clock) begin
    if (clockCounter < 24'd100_001) // 24_000_000 = 1sec なので 1/240 sec
      clockCounter <= clockCounter + 1;
    else
      clockCounter <= 24'd1;
  end

  // テストシリアル信号
  reg serialClockIn = 0;
  reg serialDataIn = 0;
  reg [6:0] serialInDummy = 7'b100_0000;
  always @(posedge clock) begin
    if (clockCounter == 24'd100) begin
      serialDataIn <= serialInDummy[0];
      serialInDummy[6:0] <= {serialInDummy[5:0], serialInDummy[6]};
    end
    else if (clockCounter == 24'd1_000)
      serialClockIn <= 1;
    else if (clockCounter == 24'd51_000)
      serialClockIn <= 0;
  end

  // DECLARATION: レジスター
  reg [7:0] serialReg = 8'b0101_1011;
  reg [7:0] digit0 = 8'b0101_1011;
  reg [7:0] digit1 = 8'b0101_1011;
  reg [7:0] digit2 = 8'b0101_1011;
  reg [7:0] digit3 = 8'b0101_1011;

  // くるくる回るバージョン
  // always @(posedge clock) begin
  //   if (clockCounter == 24'd100_001) begin
  //     if (clockCounter2 < 24'd20)
  //       clockCounter2 <= clockCounter2 + 1;
  //     else
  //       clockCounter2 <= 24'd1;
  //   end
  // end
  // always @(posedge clock) begin
  //   if (clockCounter2 == 0) begin
  //     digit0 <= 8'b0100_0000;
  //     digit1 <= 8'b0100_0000;
  //     digit2 <= 8'b0100_0000;
  //     digit3 <= 8'b0100_0000;
  //   end
  //   else if (clockCounter2 == 24'd20) begin
  //     digit0[7:0] <= {digit0[6:0], digit0[7]};
  //     digit1[7:0] <= {digit1[6:0], digit1[7]};
  //     digit2[7:0] <= {digit2[6:0], digit2[7]};
  //     digit3[7:0] <= {digit3[6:0], digit3[7]};
  //   end
  //   else begin
  //     digit0 <= digit0;
  //     digit1 <= digit1;
  //     digit2 <= digit2;
  //     digit3 <= digit3;
  //   end
  // end

  // 固定で1234表示
  //  always @(posedge clock) begin
  //    digit0 <= 8'b0010_0001;
  //    digit1 <= 8'b0101_1011;
  //    digit2 <= 8'b0111_0011;
  //    digit3 <= 8'b0110_0101;
  //  end

  // 1234でローテーション
  // always @(posedge clock) begin
  //   if (clockCounter == 24'd100_001) begin
  //     if (clockCounter2 < 24'd20)
  //       clockCounter2 <= clockCounter2 + 1;
  //     else
  //       clockCounter2 <= 24'd1;
  //   end
  // end
  // always @(posedge clock) begin
  //   if (clockCounter2 == 0) begin
  //     digit0 <= 8'b0010_0001;
  //     digit1 <= 8'b0101_1011;
  //     digit2 <= 8'b0111_0011;
  //     digit3 <= 8'b0110_0101;
  //   end
  //   else if (clockCounter2 == 24'd20) begin
  //     digit0 <= digit1;
  //     digit1 <= digit2;
  //     digit2 <= digit3;
  //     digit3 <= digit0;
  //   end
  //   else begin
  //     digit0 <= digit0;
  //     digit1 <= digit1;
  //     digit2 <= digit2;
  //     digit3 <= digit3;
  //   end
  // end
 
  // シリアル入力
  // 立ちあがりでデータを受け取る
  always @(posedge clock) begin
    if (serialClockIn == 1) begin
      serialClockLed <= 1;
      if (segmentCounter == 7) begin
        serialReg[0] <= serialDataIn;
        serialReg[1] <= serialReg[0];
        serialReg[2] <= serialReg[1];
        serialReg[3] <= serialReg[2];
        serialReg[4] <= serialReg[3];
        serialReg[5] <= serialReg[4];
        serialReg[6] <= serialReg[5];
        serialReg[7] <= serialReg[6];
        segmentCounter <= 0;
      end
      else if (segmentCounter < 7) begin
        serialReg[0] <= serialDataIn;
        serialReg[1] <= serialReg[0];
        serialReg[2] <= serialReg[1];
        serialReg[3] <= serialReg[2];
        serialReg[4] <= serialReg[3];
        serialReg[5] <= serialReg[4];
        serialReg[6] <= serialReg[5];
        serialReg[7] <= serialReg[6];
        segmentCounter <= segmentCounter + 1;
      end
      else
        segmentCounter <= 0; // 保険のリセット用。
    end
    else if (serialClockIn == 0)
      serialClockLed <= 0;
  end

  // 1桁ずつセットする
  always @(negedge clock) begin
    if (serialClockIn == 0) begin
      if (segmentCounter == 7) begin
        if (digitCounter == 0) begin
          digit0[0] <= serialReg[0];
          digit0[1] <= serialReg[1];
          digit0[2] <= serialReg[2];
          digit0[3] <= serialReg[3];
          digit0[4] <= serialReg[4];
          digit0[5] <= serialReg[5];
          digit0[6] <= serialReg[6];
          digit0[7] <= serialReg[7];
          digitCounter <= digitCounter + 1;
        end
        else if (digitCounter == 1) begin
          digit1[0] <= serialReg[0];
          digit1[1] <= serialReg[1];
          digit1[2] <= serialReg[2];
          digit1[3] <= serialReg[3];
          digit1[4] <= serialReg[4];
          digit1[5] <= serialReg[5];
          digit1[6] <= serialReg[6];
          digit1[7] <= serialReg[7];
          digitCounter <= digitCounter + 1;
        end
        else if (digitCounter == 2) begin
          digit2[0] <= serialReg[0];
          digit2[1] <= serialReg[1];
          digit2[2] <= serialReg[2];
          digit2[3] <= serialReg[3];
          digit2[4] <= serialReg[4];
          digit2[5] <= serialReg[5];
          digit2[6] <= serialReg[6];
          digit2[7] <= serialReg[7];
          digitCounter <= digitCounter + 1;
        end
        else if (digitCounter == 3) begin
          digit3[0] <= serialReg[0];
          digit3[1] <= serialReg[1];
          digit3[2] <= serialReg[2];
          digit3[3] <= serialReg[3];
          digit3[4] <= serialReg[4];
          digit3[5] <= serialReg[5];
          digit3[6] <= serialReg[6];
          digit3[7] <= serialReg[7];
          digitCounter <= 0;
        end
        else begin
          digitCounter <= 0; // 保険のリセット用。
        end
      end
    end
  end

  // 表示main処理
  always @(posedge clock) begin
    if (clockCounter == 24'd25_001) begin // 約1msごとに桁を切り替える1桁目
      digitalOutputPins <= 4'b1110;
      segmentOutputPins[0] <= digit0[0];
      segmentOutputPins[1] <= digit0[1];
      segmentOutputPins[2] <= digit0[2];
      segmentOutputPins[3] <= digit0[3];
      segmentOutputPins[4] <= digit0[4];
      segmentOutputPins[5] <= digit0[5];
      segmentOutputPins[6] <= digit0[6];
      segmentOutputPins[7] <= digit0[7];
      // for (i = 0;i < 8;i = i + 1) begin // 各segに値をセット ここは並列処理できるのでは？
      //   segmentOutputPins[i] <= digit0[i];
      // end
    end
    else if (clockCounter == 24'd50_001) begin // 約1msごとに桁を切り替える2桁目
      digitalOutputPins <= 4'b1101;
      segmentOutputPins[0] <= digit1[0];
      segmentOutputPins[1] <= digit1[1];
      segmentOutputPins[2] <= digit1[2];
      segmentOutputPins[3] <= digit1[3];
      segmentOutputPins[4] <= digit1[4];
      segmentOutputPins[5] <= digit1[5];
      segmentOutputPins[6] <= digit1[6];
      segmentOutputPins[7] <= digit1[7];
      // for (i = 0;i < 8;i = i + 1) begin
      //   segmentOutputPins[i] <= digit1[i];
      // end
    end
    else if (clockCounter == 24'd75_001) begin // 約1msごとに桁を切り替える3桁目
      digitalOutputPins <= 4'b1011;
      segmentOutputPins[0] <= digit2[0];
      segmentOutputPins[1] <= digit2[1];
      segmentOutputPins[2] <= digit2[2];
      segmentOutputPins[3] <= digit2[3];
      segmentOutputPins[4] <= digit2[4];
      segmentOutputPins[5] <= digit2[5];
      segmentOutputPins[6] <= digit2[6];
      segmentOutputPins[7] <= digit2[7];
      // for (i = 0;i < 8;i = i + 1) begin
      //   segmentOutputPins[i] <= digit2[i];
      // end
    end
    else if (clockCounter == 24'd100_001) begin // 約1msごとに桁を切り替える4桁目
      digitalOutputPins <= 4'b0111;
      segmentOutputPins[0] <= digit3[0];
      segmentOutputPins[1] <= digit3[1];
      segmentOutputPins[2] <= digit3[2];
      segmentOutputPins[3] <= digit3[3];
      segmentOutputPins[4] <= digit3[4];
      segmentOutputPins[5] <= digit3[5];
      segmentOutputPins[6] <= digit3[6];
      segmentOutputPins[7] <= digit3[7];
      // for (i = 0;i < 8;i = i + 1) begin
      //   segmentOutputPins[i] <= digit3[i];
      // end
    end
  end

endmodule
