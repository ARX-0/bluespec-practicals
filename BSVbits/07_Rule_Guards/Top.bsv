// ============================================================================
// 07 -- Rule Guards
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// A rule condition is NOT an `if`. Getting that distinction is the whole
// point of this problem.
// ============================================================================

package Top;

interface Sat_IFC;
   // Counts up from 0 by 1 each cycle and STOPS at 200. Never wraps.
   method Bit #(8) up;

   // Counts down from 100 by 1 each cycle and STOPS at 0. Never wraps.
   method Bit #(8) down;

   // Counts up by 1 each cycle while `up` is strictly below 50, then stops.
   method Bit #(8) slow;
endinterface

(* synthesize *)
module mkTop (Sat_IFC);

   // TODO: your code here.
   //
   // Write each counter as a rule with a CONDITION in parentheses:
   //
   //    rule count_up (<the condition under which this rule may fire>);
   //       ...
   //    endrule

   method Bit #(8) up;
      return 0;
   endmethod

   method Bit #(8) down;
      return 0;
   endmethod

   method Bit #(8) slow;
      return 0;
   endmethod

endmodule

endpackage
