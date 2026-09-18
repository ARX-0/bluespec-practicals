// Checker for problem 25. Instantiates YOUR tester four times -- once per
// module -- and grades the verdicts it reaches.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Duts    :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Checker_IFC ck <- mkChecker (400000);

   AbsDiff_IFC good <- mkGood;
   AbsDiff_IFC bad1 <- mkBad1;
   AbsDiff_IFC bad2 <- mkBad2;
   AbsDiff_IFC bad3 <- mkBad3;

   Tester_IFC tGood <- mkTester (good);
   Tester_IFC tBad1 <- mkTester (bad1);
   Tester_IFC tBad2 <- mkTester (bad2);
   Tester_IFC tBad3 <- mkTester (bad3);

   mkAutoFSM (
      seq
         $display ("  running your tester against 4 modules");
         $display ("  (exhaustive testers take ~65k cycles -- this is normal)");

         await (tGood.done && tBad1.done && tBad2.done && tBad3.done);

         action
            ck.check (tGood.passed,
               $format ("your tester REJECTED the CORRECT module -- it reports a bug that is not there"));
         endaction
         action
            ck.check (! tBad1.passed,
               $format ("your tester ACCEPTED broken module 1 -- it is wrong whenever b > a"));
         endaction
         action
            ck.check (! tBad2.passed,
               $format ("your tester ACCEPTED broken module 2 -- it is wrong whenever a == b"));
         endaction
         action
            ck.check (! tBad3.passed,
               $format ("your tester ACCEPTED broken module 3 -- it is wrong for exactly ONE input pair. Was your test exhaustive?"));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
