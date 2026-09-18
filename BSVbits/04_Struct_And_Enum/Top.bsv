// ============================================================================
// 04 -- Structs and Enums
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// two type definitions -- the checker shares them with your module.
// ============================================================================

package Top;

// A four-operation opcode. `deriving (Bits, ...)` is what lets this travel
// on wires: it gives the enum a 2-bit binary encoding, in declaration order.
typedef enum { OpAdd, OpSub, OpAnd, OpOr }
   Opcode deriving (Bits, Eq, FShow);

// A 10-bit instruction word. The FIRST field lands in the HIGH bits:
//    bits [9:8] op   [7:4] rd   [3:0] rs
typedef struct {
   Opcode   op;
   Bit #(4) rd;
   Bit #(4) rs;
} Instr deriving (Bits, Eq, FShow);
interface Decode_IFC;
   // Raw 10-bit word -> structured instruction.
   method Instr decode (Bit #(10) raw);

   // Structured instruction -> raw 10-bit word. The inverse of decode.
   method Bit #(10) encode (Instr i);

   // Apply the operation to two 8-bit operands.
   method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
endinterface

(* synthesize *)
module mkTop (Decode_IFC);

   // TODO: your code here.

   method Instr decode (Bit #(10) raw);
      return Instr { op: OpAdd, rd: 0, rs: 0 };
   endmethod 
   method Bit #(10) encode (Instr i);
      return 0;
   endmethod

   method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
      return 0;
   endmethod

endmodule

endpackage
