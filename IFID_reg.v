// Author: Graham Nygard, Robert Wagner

module IFID_reg(clk, PC_in, instruction, reg_rs, reg_rt, reg_rd,
                cntrl_input, arith_imm, load_save_imm, call, PC_out);

//INPUTS
input clk;
input [15:0] instruction;   // Instruction to execute
input [15:0] PC_in;         // Program counter

//OUTPUTS
output [3:0]  cntrl_input;   // Inst[15:12] - Opcode
output [3:0]  reg_rs;        // Inst[7:4]   - Register rs
output [3:0]  reg_rt;        // Inst[3:0]   - Register rt
output [3:0]  reg_rd;        // Inst[11:8]  - Register rd
output [3:0]  arith_imm;     // Inst[3:0]   - Imm of Arithmetic Inst
output [7:0]  load_save_imm; // Inst[7:0]   - Imm of Load/Save Inst
output [11:0] call;          // Inst[11:0]  - Call target
output [15:0] PC_out;        // Program counter

//INTERNAL CONTROL
logic [3:0]  CI;
logic [3:0]  RS;
logic [3:0]  RT;
logic [3:0]  RD;
logic [3:0]  AI;
logic [7:0]  LSI;
logic [11:0] CALL;
logic [15:0] PC;
logic clk_1, clk_2;

// Double flop clock for metastability
always @(posedge clk) begin
    clk_1 <= clk;
    clk_2 <= clk_1;
end

// Pipeline register will be sensitive flopped clock
always @(posedge clk_2) begin
    
   // Pass on the PC
   PC <= PC_in;
    
   // Set the input to the control unit
	//cntrl_input <= instruction[15:12];
	CI <= instruction[15:12];

   // Specify the src and dest registers
   //reg_rs <= instruction[7:4];
	//reg_rt <= instruction[3:0];
	//reg_rd <= instruction[11:8];
	RS <= instruction[7:4];
	RT <= instruction[3:0];
	RD <= instruction[11:8];
	
	// Set the immediate fields of instruction
	//arith_imm <= instruction[3:0];
	//load_save_imm <= instruction[7:0];
	AI  <= instruction[3:0];
	LSI <= instruction[7:0];
	
	// Set call target
	CALL <= instruction[11:0];
	
end

//ASSIGN INTERNAL CONTROLS TO OUTPUT
assign cntrl_input   = CI;
assign reg_rs        = RS;
assign reg_rt        = RT;
assign reg_rd        = RD;
assign arith_imm     = AI;
assign load_save_imm = LSI;
assign call          = CALL;
assign PC_in         = PC;


endmodule