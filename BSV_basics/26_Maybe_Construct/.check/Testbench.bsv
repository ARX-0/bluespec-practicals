package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Maybe_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8) x  = {4'h6, i [3:0]};
   Bool     ok = (i[4] == 1);

   mkAutoFSM (
      seq
         $display ("  32 combinations of value and ok");
         while (i < 32) seq
            action
               Maybe #(Bit #(8)) exp = tagged Valid x;
               let got = dut.wrap (x);
               ck.check (got == exp,
                  $format ("wrap(0x%02h) expected ", x) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               Maybe #(Bit #(8)) exp = tagged Invalid;
               let got = dut.nothing;
               ck.check (got == exp,
                  $format ("nothing() expected ") + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               Maybe #(Bit #(8)) exp = ok ? tagged Valid x : tagged Invalid;
               let got = dut.maybeVal (ok, x);
               ck.check (got == exp,
                  $format ("maybeVal(") + fshow (ok) + $format (",0x%02h) expected ", x)
                  + fshow (exp) + $format (", got ") + fshow (got));
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
