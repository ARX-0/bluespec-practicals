// Checker for problem 24. Preloads memory, then runs load and collect in
// the SAME cycle -- which only works if the two halves of the load are
// genuinely separate and several can be in flight.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   MemPipe_IFC dut <- mkTop;
   MemPipe_IFC gld <- mkRef;
   Checker_IFC ck  <- mkChecker (12000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0024));
   Reg #(Bit #(16)) n <- mkReg (0);
   Reg #(Bit #(9))  i <- mkReg (0);

   // The address stream, and the address whose result is due back.
   Bit #(8) addr = s[7:0];

   mkAutoFSM (
      seq
         $display ("  preloading 256 memory locations");
         while (i < 256) seq
            action
               Bit #(8) a = truncate (i);
               Bit #(8) d = (a * 3) ^ 8'h5A;
               dut.writeMem (a, d);
               gld.writeMem (a, d);
               i <= i + 1;
            endaction
         endseq

         $display ("  priming the pipeline");
         // Two loads in flight before we start collecting.
         while (n < 2) seq
            action
               dut.load (addr);
               gld.load (addr);
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq

         $display ("  200 cycles of simultaneous load + collect");
         action n <= 0; endaction
         while (n < 200) seq
            action
               dut.load (addr);
               gld.load (addr);
               let a <- dut.loadResult ();
               let b <- gld.loadResult ();
               ck.check (a == b,
                  $format ("load %0d: expected %02h, got %02h", n, b, a));
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq

         $display ("  draining");
         action n <= 0; endaction
         while (n < 2) seq
            action
               let a <- dut.loadResult ();
               let b <- gld.loadResult ();
               ck.check (a == b,
                  $format ("drain %0d: expected %02h, got %02h", n, b, a));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
