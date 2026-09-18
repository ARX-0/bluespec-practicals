// Checker for problem 17. Waits for the DUT to have a result, then compares
// it against the model's next expected value. A pipeline that drops an item
// under backpressure shows up as a wrong value, not a missing one.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   PC_IFC      dut <- mkTop;
   PC_IFC      gld <- mkRef;
   Checker_IFC ck  <- mkChecker (6000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  pulling 120 results through the pipeline");
         while (n < 120) seq
            // Blocks until the DUT has something. If your pipeline stalls
            // permanently, the watchdog reports it.
            action
               let a <- dut.result ();
               let b <- gld.result ();
               ck.check (a == b,
                  $format ("result %0d: expected %0d, got %0d", n, b, a));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
