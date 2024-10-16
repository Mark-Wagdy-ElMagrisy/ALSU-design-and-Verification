import enum_pkg::*;
module SVA(alsu_if.DUT alsuif);

    // Property for reduction operation on B when opcode is 0
    property red_B_on_opcode_0;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode == 3'h0) && 
        (alsuif.red_op_B && !alsuif.red_op_A && !alsuif.bypass_A && !alsuif.bypass_B)
        |-> ##2 (alsuif.out == (|$past(alsuif.B, 2)));
    endproperty

    // Property for XOR reduction on A when opcode is 1
    property xor_red_A_on_opcode_1;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode == 3'h1) && 
        (alsuif.red_op_A && alsuif.red_op_B && !alsuif.bypass_A && !alsuif.bypass_B)
        |-> ##2 (alsuif.out == (^$past(alsuif.A, 2)));
    endproperty

    // Property for XOR reduction on B when opcode is 1
    property xor_red_B_on_opcode_1;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode == 3'h1) && 
        (alsuif.red_op_B && !alsuif.red_op_A && !alsuif.bypass_A && !alsuif.bypass_B)
        |-> ##2 (alsuif.out == (^$past(alsuif.B, 2)));
    endproperty

    // Property for left shift operation on opcode 4
    property shift_left_on_opcode_4;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode == 3'h4) && (!alsuif.red_op_A && !alsuif.red_op_B && alsuif.direction && !alsuif.bypass_A && !alsuif.bypass_B)
        |-> ##2 (alsuif.out == { $past(alsuif.out[4:0], 1), $past(alsuif.serial_in, 2) });
    endproperty

    // Property for right shift operation on opcode 4
    property shift_right_on_opcode_4;
        @(posedge alsuif.clk) disable iff(alsuif.rst)
        (alsuif.opcode == 3'h4) && (!alsuif.red_op_A && !alsuif.red_op_B && !alsuif.direction && !alsuif.bypass_A && !alsuif.bypass_B)
        |-> ##2 (alsuif.out == { $past(alsuif.serial_in, 2), $past(alsuif.out[5:1], 1) });
    endproperty

    // Assertions and cover statements
    as_red_B_on_opcode_0: assert property (red_B_on_opcode_0) else $display("ERROR: Reduction on B failed for opcode 0");
    as_xor_red_A_on_opcode_1: assert property (xor_red_A_on_opcode_1) else $display("ERROR: XOR reduction on A failed for opcode 1");
    as_xor_red_B_on_opcode_1: assert property (xor_red_B_on_opcode_1) else $display("ERROR: XOR reduction on B failed for opcode 1");
    as_shift_left_on_opcode_4: assert property (shift_left_on_opcode_4) else $display("ERROR: Left shift failed for opcode 4");
    as_shift_right_on_opcode_4: assert property (shift_right_on_opcode_4) else $display("ERROR: Right shift failed for opcode 4");

    // Cover statements
    cv_red_B_on_opcode_0: cover property (red_B_on_opcode_0);
    cv_xor_red_A_on_opcode_1: cover property (xor_red_A_on_opcode_1);
    cv_xor_red_B_on_opcode_1: cover property (xor_red_B_on_opcode_1);
    cv_shift_left_on_opcode_4: cover property (shift_left_on_opcode_4);
    cv_shift_right_on_opcode_4: cover property (shift_right_on_opcode_4);

endmodule
