package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Sum_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         $display ("  push 4 items, then wait -- the total must settle, not run away");
         action  dut.push (8'd10);  endaction
         action  dut.push (8'd20);  endaction
         action  dut.push (8'd30);  endaction
         action  dut.push (8'd40);  endaction

         repeat (20) noAction;      // nothing pushed; the drain rule must idle

         action
            let got = dut.total;
            ck.check (got == 8'd100,
               $format ("total() after 10+20+30+40 expected 100, got %0d.\n  If this is larger, your rule kept firing on an empty FIFO.",
                        got));
         endaction

         repeat (30) noAction;      // wait even longer

         action
            let got = dut.total;
            ck.check (got == 8'd100,
               $format ("total() must stay at 100 while nothing is pushed, got %0d", got));
         endaction

         action  dut.push (8'd5);   endaction
         repeat (10) noAction;
         action
            let got = dut.total;
            ck.check (got == 8'd105,
               $format ("total() after pushing 5 more expected 105, got %0d", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
