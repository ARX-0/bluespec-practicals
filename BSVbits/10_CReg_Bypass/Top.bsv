// ============================================================================
// 10 -- CRegs: two rules, one register, one cycle
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// In problem 08 two rules wanted one register and you had to pick a winner.
// Sometimes you do not want a winner -- you want BOTH, in a defined order,
// within the same cycle. That is what a CReg is for.
// ============================================================================

package Top;

interface Drain_IFC;
   // A counter that increments by 1 every cycle.
   // Read this BEFORE this cycle's increment (i.e. the value at the start
   // of the cycle).
   method Bit #(8) current;

   // Every 4th cycle the counter is drained: its value -- INCLUDING this
   // cycle's increment -- is added to `total`, and the counter is zeroed.
   method Bit #(8) total;
endinterface

(* synthesize *)
module mkTop (Drain_IFC);

   // TODO: your code here.
   //
   // Write this as THREE rules, each doing one thing:
   //
   //    rule do_incr;                 // bump the counter, every cycle
   //    rule do_drain (phase == 3);   // every 4th cycle, drain into total
   //    rule do_phase;                // advance the phase, every cycle
   //
   // Keeping the phase counter in its own rule matters -- see HINTS.md if
   // bsc tells you do_drain can never fire.
   //
   // With a plain mkReg they conflict and one starves (problem 08). Use a
   // CReg so both can touch it in one cycle, in a defined order:
   //
   //    Reg #(Bit #(8)) cnt [2] <- mkCReg (2, 0);
   //
   // cnt[0] is the EARLIER port, cnt[1] the LATER one. A read on port 1
   // sees what port 0 wrote in the same cycle.

   method Bit #(8) current;
      return 0;
   endmethod

   method Bit #(8) total;
      return 0;
   endmethod

endmodule

endpackage
