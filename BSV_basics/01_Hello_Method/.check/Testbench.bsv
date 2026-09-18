package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Const_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         action
            let got = dut.answer;
            ck.check (got == 8'hA5,
               $format ("answer() expected 0x%02h, got 0x%02h", 8'hA5, got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
