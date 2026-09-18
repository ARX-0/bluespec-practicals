package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Enum_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         $display ("  declaration order is the encoding: 0, 1, 2");
         action
            let got = dut.redBits;
            ck.check (got == 2'd0,
               $format ("redBits() expected 0 (Red is declared first), got %0d", got));
         endaction
         action
            let got = dut.greenBits;
            ck.check (got == 2'd1,
               $format ("greenBits() expected 1, got %0d", got));
         endaction
         action
            let got = dut.blueBits;
            ck.check (got == 2'd2,
               $format ("blueBits() expected 2, got %0d", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
