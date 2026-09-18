// Golden reference for problem 04 -- specification, not solution.
// Slices the bits by hand instead of using pack/unpack, which is exactly the
// manual labour the problem is asking you to replace.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Decode_IFC);

   method Instr decode (Bit #(10) raw);
      Opcode o = case (raw[9:8])
                    2'b00: OpAdd;
                    2'b01: OpSub;
                    2'b10: OpAnd;
                    default: OpOr;
                 endcase;
      return Instr { op: o, rd: raw[7:4], rs: raw[3:0] };
   endmethod

   method Bit #(10) encode (Instr i);
      Bit #(2) o = case (i.op)
                      OpAdd: 2'b00;
                      OpSub: 2'b01;
                      OpAnd: 2'b10;
                      default: 2'b11;
                   endcase;
      return { o, i.rd, i.rs };
   endmethod

   method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
      case (op)
         OpAdd:   return x + y;
         OpSub:   return x - y;
         OpAnd:   return x & y;
         default: return x | y;
      endcase
   endmethod

endmodule

endpackage
