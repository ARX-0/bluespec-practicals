// ============================================================================
// 41 -- A FIFO
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

import FIFOF :: *;

interface Q_IFC;
   method Action                push (Bit #(8) x);
   method ActionValue #(Bit #(8)) pop ();
   method Bool                  empty ();
   method Bool                  full ();
endinterface

(* synthesize *)
module mkTop (Q_IFC);

   // A queue four elements deep.
   FIFOF #(Bit #(8)) f <- mkSizedFIFOF (4);

   method Action push (Bit #(8) x);
      noAction;                 // TODO
   endmethod

   method ActionValue #(Bit #(8)) pop ();
      return 0;                 // TODO -- return the oldest item AND remove it
   endmethod

   method Bool empty ();
      return False;             // TODO
   endmethod

   method Bool full ();
      return False;             // TODO
   endmethod

endmodule

endpackage
