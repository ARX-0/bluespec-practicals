// ============================================================================
// 13 -- Implicit Conditions: the handshake you don't have to wire
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Build a 4-deep circular buffer BY HAND. You will use the library FIFO from
// problem 16 onwards; doing it once yourself is how the library stops being
// magic.
// ============================================================================

package Top;

import Vector :: *;

interface Buf_IFC;
   // Add an item. MUST be guarded: only callable when the buffer is not full.
   method Action enq (Bit #(8) x);

   // Remove and return the oldest item (FIFO order).
   // MUST be guarded: only callable when the buffer is not empty.
   method ActionValue #(Bit #(8)) deq ();

   // Status, always readable.
   method Bool     notFull ();
   method Bool     notEmpty ();
   method Bit #(3) depth ();      // 0..4
endinterface

(* synthesize *)
module mkTop (Buf_IFC);

   // TODO: your code here.
   //
   // Suggested state:
   //    Vector #(4, Reg #(Bit #(8))) data <- replicateM (mkReg (0));
   //    Reg #(Bit #(2)) head  <- mkReg (0);   // next slot to read
   //    Reg #(Bit #(2)) tail  <- mkReg (0);   // next slot to write
   //    Reg #(Bit #(3)) cnt   <- mkReg (0);   // how many items, 0..4
   //
   // head and tail are Bit#(2), so they wrap 3 -> 0 by themselves. That is
   // the whole "circular" part.
   //
   // A GUARDED method is written with `if (...)` after the argument list:
   //
   //    method Action enq (Bit #(8) x) if (<condition>);
   //
   // That condition is an IMPLICIT CONDITION. Read the README on what it
   // does -- it is not an `if` around the body.

   method Action enq (Bit #(8) x);
      noAction;
   endmethod

   method ActionValue #(Bit #(8)) deq ();
      return 0;
   endmethod

   method Bool     notFull ()  = False;
   method Bool     notEmpty () = False;
   method Bit #(3) depth ()    = 0;

endmodule

endpackage
