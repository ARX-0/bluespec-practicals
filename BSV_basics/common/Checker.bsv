// ============================================================================
// Checker.bsv -- shared pass/fail bookkeeping for every BSVbits problem.
//
// You never need to edit or even read this file to solve a problem, but you
// are welcome to: it is ordinary BSV, and by problem 25 you will be writing
// something very like it yourself.
//
// The `Run` script decides PASS/FAIL by looking for the line
//     RESULT: PASS   /   RESULT: FAIL
// which `done` emits. Nothing else in the output is load-bearing.
// ============================================================================

package Checker;

interface Checker_IFC;
   // Record one comparison. `ok` is the verdict; `ctx` describes the inputs
   // and values involved, and is printed only for the FIRST failure so a
   // badly broken module does not bury you in output.
   method Action check (Bool ok, Fmt ctx);

   // Print the summary and the RESULT: line. Call once, at the end.
   method Action done ();

   // Has anything failed so far?
   method Bool failed ();

   // Cycles since reset -- handy for your own $display calls.
   method Bit #(32) cycle ();
endinterface

// maxCycles is a deadlock watchdog. In BSV a method with an implicit
// condition that never becomes ready does not error -- it simply never
// fires, and the simulation runs forever. The watchdog turns that silent
// hang into a legible failure.
module mkChecker #(Bit #(32) maxCycles) (Checker_IFC);

   Reg #(Bit #(32)) cyc     <- mkReg (0);
   Reg #(Bit #(32)) nCheck  <- mkReg (0);
   Reg #(Bit #(32)) nFail   <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule count_cycles;
      cyc <= cyc + 1;
   endrule

   rule watchdog (cyc > maxCycles);
      $display ("");
      $display ("  TIMEOUT after %0d cycles -- your module appears to be stalled.", cyc);
      $display ("  In BSV this usually means a guarded method never became ready,");
      $display ("  so the rule that calls it can never fire. Check the implicit");
      $display ("  conditions on the methods your design uses.");
      $display ("");
      $display ("RESULT: FAIL");
      $finish (0);
   endrule

   method Action check (Bool ok, Fmt ctx);
      nCheck <= nCheck + 1;
      if (! ok) begin
         if (nFail == 0)
            $display ($format ("  FIRST MISMATCH at cycle %0d: ", cyc) + ctx);
         nFail <= nFail + 1;
      end
   endmethod

   method Action done ();
      $display ("");
      $display ("  checks: %0d passed, %0d failed, %0d total",
                nCheck - nFail, nFail, nCheck);
      if (nFail == 0) begin
         if (nCheck == 0) begin
            // A testbench that checked nothing must never report success.
            $display ("  no checks ran -- treating as failure");
            $display ("RESULT: FAIL");
         end
         else
            $display ("RESULT: PASS");
      end
      else
         $display ("RESULT: FAIL");
   endmethod

   method Bool     failed = (nFail != 0);
   method Bit #(32) cycle = cyc;
endmodule

endpackage
