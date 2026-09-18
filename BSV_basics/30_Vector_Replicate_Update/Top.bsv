// ============================================================================
// 30 -- replicate and update
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

import Vector      :: *;
import BuildVector :: *;

interface Fill_IFC;
   // Four copies of x.
   method Vector #(4, Bit #(8)) allSame (Bit #(8) x);

   // v, but with element idx replaced by x.
   method Vector #(4, Bit #(8)) setOne (Vector #(4, Bit #(8)) v,
                                        Bit #(2) idx, Bit #(8) x);

   // All zeros except element 0, which is x.
   method Vector #(4, Bit #(8)) onlyFirst (Bit #(8) x);
endinterface

(* synthesize *)
module mkTop (Fill_IFC);

   method Vector #(4, Bit #(8)) allSame (Bit #(8) x);
      return replicate (0);     // TODO
   endmethod

   method Vector #(4, Bit #(8)) setOne (Vector #(4, Bit #(8)) v,
                                        Bit #(2) idx, Bit #(8) x);
      return replicate (0);     // TODO
   endmethod

   method Vector #(4, Bit #(8)) onlyFirst (Bit #(8) x);
      return replicate (0);     // TODO
   endmethod

endmodule

endpackage
