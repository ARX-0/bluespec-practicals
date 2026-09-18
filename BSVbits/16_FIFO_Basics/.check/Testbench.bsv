// Checker for problem 16. Only issues an operation when BOTH modules are
// ready, so the two may have different capacities; what must match is the
// ORDER and VALUES of what comes out.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Stage_IFC   dut <- mkTop;
   Stage_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (6000);

   Reg #(Bit #(32)) s     <- mkReg (seedFrom (32'h0000_0016));
   Reg #(Bit #(16)) n     <- mkReg (0);
   Reg #(Bit #(16)) nOut  <- mkReg (0);

   Bit #(8) v = s[7:0];

   mkAutoFSM (
      seq
         $display ("  300 randomised enq / deq rounds");
         while (n < 300) seq
            if ((s[16] == 0) && dut.notFull () && gld.notFull ()) seq
               action
                  dut.enq (v);
                  gld.enq (v);
               endaction
            endseq

            if ((s[16] == 1) && dut.notEmpty () && gld.notEmpty ()) seq
               action
                  let a <- dut.deq ();
                  let b <- gld.deq ();
                  ck.check (a == b,
                     $format ("output %0d: expected %02h, got %02h", nOut, b, a));
                  nOut <= nOut + 1;
               endaction
            endseq

            action
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq

         // Drain whatever is left in both, still comparing.
         while (dut.notEmpty () && gld.notEmpty ()) seq
            action
               let a <- dut.deq ();
               let b <- gld.deq ();
               ck.check (a == b,
                  $format ("drain %0d: expected %02h, got %02h", nOut, b, a));
               nOut <= nOut + 1;
            endaction
         endseq

         action
            $display ("  %0d items passed through", nOut);
            // A module that never accepts or never produces would sail
            // through the loops above having done nothing. Insist on flow.
            ck.check (nOut > 40,
               $format ("only %0d items flowed through -- expected far more", nOut));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
