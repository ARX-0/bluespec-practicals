// Checker for problem 06. Both modules free-run from reset, so we just watch
// them for 200 cycles and compare all three outputs every cycle.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Counter_IFC dut <- mkTop;
   Counter_IFC gld <- mkRef;
   Checker_IFC ck  <- mkChecker (2000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  observing 200 free-running cycles");
         while (n < 200) seq
            action
               // All three compared in one cycle: a broken counter usually
               // breaks all of them, and this keeps the modules in lockstep.
               Bool okC = (dut.count   == gld.count);
               Bool okD = (dut.delayed == gld.delayed);
               Bool okE = (dut.evens   == gld.evens);
               ck.check (okC && okD && okE,
                  $format ("cycle %0d: count exp %0d got %0d | delayed exp %0d got %0d | evens exp %0d got %0d",
                           n, gld.count, dut.count, gld.delayed, dut.delayed,
                           gld.evens, dut.evens));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
