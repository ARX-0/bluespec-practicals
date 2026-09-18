package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Shift_IFC   dut <- mkTop;
   Shift_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (3000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  255 cycles -- a full LFSR period");
         while (n < 255) seq
            action
               Bool okL = (dut.lfsr     == gld.lfsr);
               Bool okD = (dut.delayed3 == gld.delayed3);
               ck.check (okL && okD,
                  $format ("cycle %0d: lfsr exp %02h got %02h | delayed3 exp %0d got %0d",
                           n, gld.lfsr, dut.lfsr, gld.delayed3, dut.delayed3));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
