// Checker for problem 01. Exhaustive: all 8 combinations of (sel, b, a),
// each of the four methods checked on its own cycle so a failure report
// names exactly one method.

package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Gates_IFC   dut <- mkTop;
   Gates_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(4)) i <- mkReg (0);

   // Decompose the loop counter into the three input bits.
   Bit #(1) a   = i[0];
   Bit #(1) b   = i[1];
   Bit #(1) sel = i[2];

   mkAutoFSM (
      seq
         $display ("  exhaustive over all input combinations");
         while (i < 8) seq
            action
               let got = dut.nand2 (a, b);  let exp = gld.nand2 (a, b);
               ck.check (got == exp,
                  $format ("nand2(a=%0d, b=%0d) expected %0d, got %0d", a, b, exp, got));
            endaction
            action
               let got = dut.nor2 (a, b);   let exp = gld.nor2 (a, b);
               ck.check (got == exp,
                  $format ("nor2(a=%0d, b=%0d) expected %0d, got %0d", a, b, exp, got));
            endaction
            action
               let got = dut.xnor2 (a, b);  let exp = gld.xnor2 (a, b);
               ck.check (got == exp,
                  $format ("xnor2(a=%0d, b=%0d) expected %0d, got %0d", a, b, exp, got));
            endaction
            action
               let got = dut.mux2 (sel, a, b);  let exp = gld.mux2 (sel, a, b);
               ck.check (got == exp,
                  $format ("mux2(sel=%0d, a=%0d, b=%0d) expected %0d, got %0d",
                           sel, a, b, exp, got));
            endaction
            action
               i <= i + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
