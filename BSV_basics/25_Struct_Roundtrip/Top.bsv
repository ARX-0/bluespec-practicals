// ============================================================================
// 25 -- Decode, Encode, Execute
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// two typedefs -- the checker shares them with your module.
//
// This is BSVbits problem 04. Every piece of it is something you have already
// done here: 18-20 for the enum, 21-24 for the struct.
// ============================================================================

package Top;

typedef enum { OpAdd, OpSub, OpAnd, OpOr }
   Opcode deriving (Bits, Eq, FShow);

// A 10-bit instruction word:  [9:8] op   [7:4] rd   [3:0] rs
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

   method Instr decode (Bit #(10) raw);
      return Instr { op: OpAdd, rd: 0, rs: 0 };// TODO
   endmethod

   method Bit #(10) encode (Instr i);
      return 0;                 // TODO
   endmethod

   method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
