`ifndef ALU
`define ALU

`define ALU_FLAG_OFLOW 4'b0001
`define ALU_FLAG_CARRY 4'b0010
`define ALU_FLAG_ZERO 4'b0100
`define ALU_FLAG_NEG 4'b1000

`define ALU_ADD 2'b00
`define ALU_SUB 2'b01
`define ALU_AND 2'b10
`define ALU_OR 2'b11

`endif  // ALU
