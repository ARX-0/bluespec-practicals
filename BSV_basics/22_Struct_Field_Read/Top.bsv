// ============================================================================
// 22 -- Reading Struct Fields
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// typedef -- the checker shares the type with your module.
// ============================================================================

package Top;

typedef struct {
   Bit #(8) x;
   Bit #(8) y;
} Point deriving (Bits, Eq, FShow);

interface Read_IFC;
   method Bit #(8) getX (Point p);
   method Bit #(8) getY (Point p);

   // x + y.
   method Bit #(8) sumXY (Point p);

   // The same point with its two fields exchanged.
   method Point swapXY (Point p);
endinterface

(* synthesize *)
module mkTop (Read_IFC);

   method Bit #(8) getX (Point p);
      return 0;                 // TODO
   endmethod

   method Bit #(8) getY (Point p);
      return 0;                 // TODO
   endmethod

   method Bit #(8) sumXY (Point p);
      return 0;                 // TODO
   endmethod

   method Point swapXY (Point p);
      return Point { x: 0, y: 0 };// TODO
   endmethod

endmodule

endpackage
