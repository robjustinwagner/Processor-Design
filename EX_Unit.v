// Author: Graham Nygard, Robert Wagner

module EX_Unit(clk, mem_to_reg_in, reg_to_mem_in, branch_cond,ret_wb,
               PC_stack_pointer, alu_src, alu_op, shift, load_half_imm,
               rd_data_1, rd_data_2, sign_ext, ret_future_in, reg_rd_in,
               call_target, PC_in, call, branch,
                  mem_to_reg_out, reg_to_mem_out, reg_rd_out,
                  ret_future_out, alu_result, PC_update, PC_src,
                  PC_update_done);
;
////////////////////////////INPUTS/////////////////////////////////

input        clk;
input        mem_to_reg_in;    // LW signal to Memory unit 
input        reg_to_mem_in;    // SW signal to Memory unit

//PC UPDATER 
input [2:0]	 branch_cond;      // Branch condition
input [11:0]	call_target;      // Call target

input        branch;
input        call;

input [15:0] PC_in;            // PC for branch/call/ret

//RETURN SIGNALS
input        ret_future_in;    // Future ret_wb signal

input        ret_wb;           // Return signal when SP is ready
input [15:0] PC_stack_pointer; // SP value for PC update

//ALU INPUTS
input	       alu_src;          // ALU operand 2 seleciton

input [2:0]	 alu_op;           // ALU operation
input [3:0]  shift;            // ALU shift input
input [7:0]  load_half_imm;    // ALU imm load input
input [15:0] rd_data_1;        // ALU operand 1
input [15:0] rd_data_2;        // ALU operand 2
input [15:0]	sign_ext;         // ALU operand 2

//PIPELINE TO PIPELINE
input [3:0]  reg_rd_in;        // Future Regfile dest

///////////////////////////////////////////////////////////////////

///////////////////////////OUTPUTS/////////////////////////////////

//PIPE TO PIPE
output logic        mem_to_reg_out; // LW signal to Memory unit 
output logic        reg_to_mem_out; // SW signal to Memory unit
output logic        ret_future_out; // Future ret_wb signal
output logic [3:0]  reg_rd_out;     // Future Regfile dest

output logic        PC_update_done; // Complete branch/call/ret/ update
output logic        PC_src;         // PC source selection

output logic [15:0] alu_result;     // Results of ALU operation

output logic [15:0] PC_update;      // Updated PC for branch/call/ret

///////////////////////////////////////////////////////////////////

////////////////////////INTERCONNECTS//////////////////////////////

logic alu_done;

logic [2:0] set_flags;
logic [2:0] updated_flags;

///////////////////////////////////////////////////////////////////


/////////////////////MODULE INSTANTIATIONS/////////////////////////

ALU       alu(.data_one(read_data_1), .data_two(read_data_2),
              .shift(shift), .load_half_imm(load_half_imm),
              .control(alu_op), .result(alu_result),
              .flags(set_flags));		                           

Flag_reg  flags(.clk(clk), .en(alu_done), .d(set_flags), .q(updated_flags));

PC_Update pc_update(.PC_in(PC_in), .PC_stack_pointer(PC_stack_pointer), .alu_done(alu_done), 
                    .flags(updated_flags), .call_imm(call_imm), .sign_ext(sign_ext),
                    .branch_cond(branch_cond), .branch(branch), .call(call), .ret(ret),
                    .PC_update(PC_update), .PC_src(PC_src), .update_done(PC_update_done));
 
Forwarding_Unit FU(); //FIX THIS

///////////////////////////////////////////////////////////////////


endmodule