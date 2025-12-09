module Vedic_multiplier_8x8_Combinational (
	input logic [7:0] A,  
	input logic [7:0] B,  
	output logic [15:0] P  
);

logic [3:0] Al, Ah, Bl, Bh;
assign Al = A[3:0]; 
assign Ah = A[7:4]; 
assign Bl = B[3:0]; 
assign Bh = B[7:4]; 

logic [7:0] m1, m2, m3, m4;

vedic_multiplier_4x4 V1 (.A(Al), .B(Bl), .P(m1));
vedic_multiplier_4x4 V2 (.A(Al), .B(Bh), .P(m2));
vedic_multiplier_4x4 V3 (.A(Ah), .B(Bl), .P(m3));
vedic_multiplier_4x4 V4 (.A(Ah), .B(Bh), .P(m4));

logic [7:0] sum1;
logic carry1;
ripple_carry_adder_8x8 RCA1 (
    .A(m2), 
    .B(m3), 
    .Cin(1'b0), 
    .Sum(sum1), 
    .Cout(carry1)
); 

logic [7:0] m1_mid_term;
assign m1_mid_term = m1[7:4];

logic [7:0] sum2;
logic carry2;
ripple_carry_adder_8x8 RCA2 (
    .A(sum1), 
    .B({4'b0000, m1_mid_term}), 
    .Cin(1'b0), 
    .Sum(sum2), 
    .Cout(carry2)
);

logic [7:0] sum3;
logic carry3;
ripple_carry_adder_8x8 RCA3 (
    .A(m4), 
    .B({carry1, 3'b000, sum2[7:4]}), 
    .Cin(1'b0), 
    .Sum(sum3), 
    .Cout(carry3)
);

assign P = {carry3, sum3, sum2[3:0], m1[3:0]};

endmodule
