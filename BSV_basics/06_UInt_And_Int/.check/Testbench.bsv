package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Num_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(4)) i <- mkReg (0);

   // Eight (a,b) pairs, chosen so that the signed and unsigned answers differ.
   Bit #(8) ra = case (i)
                    0: 8'd10;  1: 8'd200; 2: 8'd0;   3: 8'd255;
                    4: 8'd128; 5: 8'd127; 6: 8'd7;   default: 8'd200;
                 endcase;
   Bit #(8) rb = case (i)
                    0: 8'd20;  1: 8'd100; 2: 8'd255; 3: 8'd0;
                    4: 8'd127; 5: 8'd128; 6: 8'd7;   default: 8'd200;
                 endcase;

   UInt #(8) au = unpack (ra);   UInt #(8) bu = unpack (rb);
   Int  #(8) as = unpack (ra);   Int  #(8) bs = unpack (rb);

   mkAutoFSM (
      seq
         $display ("  eight pairs, incl. ones where signed and unsigned disagree");
         while (i < 8) seq
            action
               let got = dut.sumU (au, bu);
               ck.check (got == (au + bu),
                  $format ("sumU(%0d,%0d) expected %0d, got %0d", au, bu, au + bu, got));
            endaction
            action
               let got = dut.lessU (au, bu);
               ck.check (got == (au < bu),
                  $format ("lessU(%0d,%0d) expected ", au, bu) + fshow (au < bu)
                  + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.lessS (as, bs);
               ck.check (got == (as < bs),
                  $format ("lessS(%0d,%0d) expected ", as, bs) + fshow (as < bs)
                  + $format (", got ") + fshow (got));
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
