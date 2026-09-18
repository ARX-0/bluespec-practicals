// ============================================================================
// 21 -- Building a Struct
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// typedef -- the checker shares the type with your module.
// ============================================================================

package Top;

typedef struct {
   Bit #(8) x;
   Bit #(8) y;
} Point deriving (Bits, Eq, FShow);

interface Point_IFC;
   // Build the point (a, b).
   method Point make (Bit #(8) a, Bit #(8) b);

   // The point (0, 0).
   method Point origin ();

   // The point (v, v).
   method Point diagonal (Bit #(8) v);
endinterface

(* synthesize *)
module mkTop (Point_IFC);

   method Point make (Bit #(8) a, Bit #(8) b);
      return Point { x: 0, y: 0 };// TODO
   endmethod

   method Point origin ();
      return Point { x: 0, y: 0 };// TODO
   endmethod

   method Point diagonal (Bit #(8) v);
      return Point { x: 0, y: 0 };// TODO
   endmethod

endmodule

endpackage
