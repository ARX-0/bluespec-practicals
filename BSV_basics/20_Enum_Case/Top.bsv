// ============================================================================
// 20 -- case over an Enum
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// typedef -- the checker shares the type with your module.
// ============================================================================

package Top;

typedef enum { OpAdd, OpSub, OpAnd, OpOr }
   Opcode deriving (Bits, Eq, FShow);

interface Alu_IFC;
   //   OpAdd -> x + y     OpSub -> x - y
   //   OpAnd -> x & y     OpOr  -> x | y
   method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
endinterface

(* synthesize *)
module mkTop (Alu_IFC);

method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
      return 0;                 // TODO
endmethod

endmodule

endpackage
