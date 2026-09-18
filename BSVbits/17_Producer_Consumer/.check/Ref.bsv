// Golden reference for problem 17 -- specification, not solution.
// A pure model: no FIFOs, no producer, no consumer, no timing. It just
// knows that the nth result must be n*n. That is the contract; how your
// pipeline schedules itself is up to it, but it may not drop or reorder.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (PC_IFC);

   Reg #(Bit #(8)) n <- mkReg (0);

   method ActionValue #(Bit #(16)) result ();
      n <= n + 1;
      Bit #(16) w = zeroExtend (n);
      return w * w;
   endmethod

   method Bool hasResult () = True;

endmodule

endpackage
