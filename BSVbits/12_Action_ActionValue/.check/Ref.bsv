// Golden reference for problem 12 -- specification, not solution.
// Uses the explicit ._read / ._write forms that `<=` is sugar for. Same
// hardware; shows you what a Reg interface actually is underneath.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Acc_IFC);

   Reg #(Bit #(8)) t <- mkReg (0);
   Reg #(Bit #(8)) c <- mkReg (0);

   method Action add (Bit #(8) x);
      t._write (t._read + x);
      c._write (c._read + 1);
   endmethod

   method ActionValue #(Bit #(8)) takeAndClear ();
      t._write (0);
      return t._read;
   endmethod

   method Bit #(8) total () = t._read;
   method Bit #(8) count () = c._read;

endmodule

endpackage
