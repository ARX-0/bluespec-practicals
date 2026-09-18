// ============================================================================
// 29 -- Vector
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

import Vector      :: *;
import BuildVector :: *;

interface Vec_IFC;
   // Build the 4-element vector [a, b, c, d].
   method Vector #(4, Bit #(8)) build (Bit #(8) a, Bit #(8) b,
                                       Bit #(8) c, Bit #(8) d);

   // Element number idx. idx is a run-time value, not a constant.
   method Bit #(8) elemAt (Vector #(4, Bit #(8)) v, Bit #(2) idx);

   // The last element.
   method Bit #(8) lastElem (Vector #(4, Bit #(8)) v);
endinterface

(* synthesize *)
module mkTop (Vec_IFC);

   method Vector #(4, Bit #(8)) build (Bit #(8) a, Bit #(8) b,
                                       Bit #(8) c, Bit #(8) d);
      return replicate (0);     // TODO
   endmethod

   method Bit #(8) elemAt (Vector #(4, Bit #(8)) v, Bit #(2) idx);
      return 0;                 // TODO
   endmethod

   method Bit #(8) lastElem (Vector #(4, Bit #(8)) v);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
