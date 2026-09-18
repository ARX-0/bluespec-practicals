// ============================================================================
// 32 -- fold
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

import Vector      :: *;
import BuildVector :: *;

// TODO: allNonZero needs a small function to map over. Write it here.


interface Fold_IFC;
   // The sum of all four elements, wrapping at 8 bits.
   method Bit #(8) total (Vector #(4, Bit #(8)) v);

   // The largest element.
   method Bit #(8) biggest (Vector #(4, Bit #(8)) v);

   // True if every element is non-zero.
   method Bool allNonZero (Vector #(4, Bit #(8)) v);
endinterface

(* synthesize *)
module mkTop (Fold_IFC);

   method Bit #(8) total (Vector #(4, Bit #(8)) v);
      return 0;                 // TODO
   endmethod

   method Bit #(8) biggest (Vector #(4, Bit #(8)) v);
      return 0;                 // TODO
   endmethod

   method Bool allNonZero (Vector #(4, Bit #(8)) v);
      return False;             // TODO
   endmethod

endmodule

endpackage
