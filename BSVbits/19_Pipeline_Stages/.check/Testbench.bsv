// Checker for problem 19. First fills the pipeline, then runs 150 cycles of
// simultaneous put+get -- which only works if the design is genuinely
// elastic. A pipeline that cannot overlap input and output stalls, and the
// watchdog reports it.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Pipe_IFC    dut <- mkTop;
   Pipe_IFC    gld <- mkRef;
   Checker_IFC ck  <- mkChecker (6000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0019));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8) v = s[7:0];

   mkAutoFSM (
      seq
         $display ("  filling the pipeline");
         // Four items in, nothing out: enough to occupy all three stages.
         while (n < 4) seq
            action
               dut.put (v);
               gld.put (v);
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq

         $display ("  150 cycles of simultaneous put + get");
         action n <= 0; endaction
         while (n < 150) seq
            action
               // Both in one cycle. This is the elasticity test.
               dut.put (v);
               gld.put (v);
               let a <- dut.get ();
               let b <- gld.get ();
               ck.check (a == b,
                  $format ("item %0d: expected %0d, got %0d", n, b, a));
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq

         $display ("  draining");
         action n <= 0; endaction
         while (n < 4) seq
            action
               let a <- dut.get ();
               let b <- gld.get ();
               ck.check (a == b,
                  $format ("drain %0d: expected %0d, got %0d", n, b, a));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
