import enum_pkg::*;

module golden_ALSU(alsu_if.REF alsuif);
parameter INPUT_PRIORITY = alsuif.INPUT_PRIORITY;
parameter FULL_ADDER = alsuif.FULL_ADDER;

logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
logic [2:0] opcode;
logic signed [2:0] A, B;
logic [15:0] leds;
logic signed [5:0] out;

assign clk = alsuif.clk;
assign rst = alsuif.rst;
assign cin = alsuif.cin;
assign red_op_A = alsuif.red_op_A;
assign red_op_B = alsuif.red_op_B;
assign bypass_A = alsuif.bypass_A;
assign bypass_B = alsuif.bypass_B;
assign direction = alsuif.direction;
assign serial_in = alsuif.serial_in;
assign opcode = alsuif.opcode;
assign A = alsuif.A;
assign B = alsuif.B;
assign alsuif.leds_ref = leds;
assign alsuif.out_ref = out;

reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg signed [1:0] cin_reg;
reg [2:0] opcode_reg;
reg signed [2:0] A_reg, B_reg;

wire invalid_red_op, invalid_opcode, invalid;

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

//Registering input signals
always @(posedge clk or posedge rst) begin
  if(rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= cin;
     red_op_B_reg <= red_op_B;
     red_op_A_reg <= red_op_A;
     bypass_B_reg <= bypass_B;
     bypass_A_reg <= bypass_A;
     direction_reg <= direction;
     serial_in_reg <= serial_in;
     opcode_reg <= opcode;
     A_reg <= A;
     B_reg <= B;
  end
end

//leds output blinking 
always @(posedge clk or posedge rst) begin
  if(rst) begin
     leds <= 0;
  end else begin
      if (invalid)
        leds <= ~leds;
      else
        leds <= 0;
  end
end

//ALSU output processing
always @(posedge clk or posedge rst) begin
  if(rst) begin
    out <= 0;
  end
  else begin
    if (bypass_A_reg && bypass_B_reg)
      out <= (alsuif.INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      out <= A_reg;
    else if (bypass_B_reg)
      out <= B_reg;
    else if(invalid)
      out <= 0;
    else begin
        case (opcode_reg)
          3'h0: begin 
            if (red_op_A_reg && red_op_B_reg)
              out = (alsuif.INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              out <= |A_reg;
            else if (red_op_B_reg)
              out <= |B_reg;
            else 
              out <= A_reg | B_reg;
          end
          3'h1: begin
            if (red_op_A_reg && red_op_B_reg)
              out <= (alsuif.INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              out <= ^A_reg;
            else if (red_op_B_reg)
              out <= ^B_reg;
            else 
              out <= A_reg ^ B_reg;
          end
          3'h2: 
		if(alsuif.FULL_ADDER == "ON")
			out <= A_reg + B_reg + cin_reg;
		else
			out <= A_reg + B_reg;
          3'h3: out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              out <= {out[4:0], serial_in_reg};
            else
              out <= {serial_in_reg, out[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              out <= {out[4:0], out[5]};
            else
              out <= {out[0], out[5:1]};
          end
        endcase
    end 
  end
end

endmodule
