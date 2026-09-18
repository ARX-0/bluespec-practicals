// Checker for problem 12. Drives both modules with an identical call
// sequence and compares state after every operation.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Acc_IFC     dut <- mkTop;
   Acc_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (4000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0012));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8) v = s[7:0];

   mkAutoFSM (
      seq
         $display ("  120 rounds of add / takeAndClear");
         while (n < 120) seq
            action
               dut.add (v);
               gld.add (v);
            endaction
            action
               Bool okT = (dut.total () == gld.total ());
               Bool okC = (dut.count () == gld.count ());
               ck.check (okT && okC,
                  $format ("after add(%02h): total exp %0d got %0d | count exp %0d got %0d",
                           v, gld.total (), dut.total (), gld.count (), dut.count ()));
            endaction

            // Roughly one round in four, drain the accumulator and check the
            // returned value as well as the state left behind.
            if (s[9:8] == 0) seq
               action
                  let a <- dut.takeAndClear ();
                  let b <- gld.takeAndClear ();
                  ck.check (a == b,
                     $format ("takeAndClear returned exp %0d, got %0d", b, a));
               endaction
               action
                  ck.check (dut.total () == gld.total (),
                     $format ("total after clear: exp %0d, got %0d",
                              gld.total (), dut.total ()));
               endaction
            endseq

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
