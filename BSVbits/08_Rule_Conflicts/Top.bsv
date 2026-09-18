// ============================================================================
// 08 -- Rule Conflicts and Scheduling
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// This problem is DIFFERENT. The two rules below are already written, and
// they are already correct in isolation. Run the checker FIRST, before you
// change anything, and read what bsc says about the schedule.
//
// Your job is to fix the schedule, not the logic.
// ============================================================================

package Top;

interface Conflict_IFC;
   // Counts 0,1,2,...,9,0,1,2,...  -- it must RESET at 9, never reach 10.
   method Bit #(8) count;

   // How many times the reset has happened.
   method Bit #(8) resets;
endinterface

(* synthesize *)
module mkTop (Conflict_IFC);

   Reg #(Bit #(8)) count_r  <- mkReg (0);
   Reg #(Bit #(8)) resets_r <- mkReg (0);

   // TODO: these two rules both write count_r, so they conflict. bsc will
   // pick an order for you -- and it picks the wrong one. Make your intent
   // explicit instead.
   //
   // Add ONE attribute above the two rules. See README.md.

   rule do_incr;
      count_r <= count_r + 1;
   endrule

   rule do_reset (count_r == 9);
      count_r  <= 0;
      resets_r <= resets_r + 1;
   endrule

   method Bit #(8) count  = count_r;
   method Bit #(8) resets = resets_r;

endmodule

endpackage
