// ============================================================================
// 42 -- Guards You Did Not Write
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// The last problem. Everything here you have already done -- a FIFO (41), a
// rule (34) and a register (33). What is new is what the rule does NOT need.
// ============================================================================

package Top;

import FIFOF :: *;

interface Sum_IFC;
   // Hand an item to the module.
   method Action push (Bit #(8) x);

   // The running total of every item the module has consumed so far.
   method Bit #(8) total ();
endinterface

(* synthesize *)
module mkTop (Sum_IFC);

   FIFOF #(Bit #(8)) f   <- mkSizedFIFOF (4);
   Reg #(Bit #(8))   acc <- mkReg (0);

   // TODO: one rule that takes the front item off the FIFO and adds it to acc.
   //
   //       Write it with NO condition of its own -- `rule drain;`, not
   //       `rule drain (f.notEmpty);`. Read the README for why that is
   //       correct rather than lazy.


   method Action push (Bit #(8) x);
      f.enq (x);
   endmethod

   method Bit #(8) total ();
      return acc;
   endmethod

endmodule

endpackage
