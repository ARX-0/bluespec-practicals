package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Alu_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(7)) i <- mkReg (0);

   Opcode   op = unpack (i [1:0]);
   Bit #(8) x  = {2'b01, i [5:0]};
   Bit #(8) y  = {i [5:0], 2'b11};

   Bit #(8) exp = case (op)
                     OpAdd: x + y;
                     OpSub: x - y;
                     OpAnd: x & y;
                     OpOr:  x | y;
                  endcase;

   mkAutoFSM (
      seq
         $display ("  every opcode, on 64 operand pairs");
         while (i < 64) seq
            action
               let got = dut.execute (op, x, y);
               ck.check (got == exp,
                  $format ("execute(") + fshow (op)
                  + $format (", 0x%02h, 0x%02h) expected 0x%02h, got 0x%02h",
                            x, y, exp, got));
            endaction
            action
               i <= i + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
