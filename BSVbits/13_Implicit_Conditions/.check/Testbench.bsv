// Checker for problem 13. Drives a random enq/deq sequence, but only issues
// a call when the REFERENCE says it is legal. If your guards are wrong the
// modules diverge; if your guards are missing entirely the rule blocks and
// the watchdog reports a stall.
package Testbench;

import StmtFSM :: *;
import Vector  :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Buf_IFC     dut <- mkTop;
   Buf_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (5000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0013));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8) v = s[7:0];

   mkAutoFSM (
      seq
         $display ("  250 rounds of randomised enq / deq");
         while (n < 250) seq

            // Bias toward enq early on so the buffer actually fills.
            if ((s[16] == 0) && gld.notFull ()) seq
               action
                  dut.enq (v);
                  gld.enq (v);
               endaction
            endseq

            if ((s[16] == 1) && gld.notEmpty ()) seq
               action
                  let a <- dut.deq ();
                  let b <- gld.deq ();
                  ck.check (a == b,
                     $format ("deq returned exp %02h, got %02h", b, a));
               endaction
            endseq

            action
               Bool okF = (dut.notFull ()  == gld.notFull ());
               Bool okE = (dut.notEmpty () == gld.notEmpty ());
               Bool okD = (dut.depth ()    == gld.depth ());
               ck.check (okF && okE && okD,
                  $format ("round %0d: notFull exp ", n, fshow (gld.notFull ()),
                           " got ", fshow (dut.notFull ()),
                           " | notEmpty exp ", fshow (gld.notEmpty ()),
                           " got ", fshow (dut.notEmpty ()),
                           " | depth exp %0d got %0d", gld.depth (), dut.depth ()));
            endaction

            action
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
