// The four modules your tester is run against.
//
// You are not meant to read this file -- doing so turns "write a thorough
// testbench" into "write a testbench that targets these three bugs", which
// is the opposite of the exercise. Come back afterwards if you like.

package Duts;
import Top :: *;

// The correct one. Your tester must ACCEPT this.
(* synthesize *)
module mkGood (AbsDiff_IFC);
   method Bit #(8) absdiff (Bit #(8) a, Bit #(8) b);
      return (a >= b) ? (a - b) : (b - a);
   endmethod
endmodule

// Bug 1: forgets that the subtraction is unsigned and wraps.
(* synthesize *)
module mkBad1 (AbsDiff_IFC);
   method Bit #(8) absdiff (Bit #(8) a, Bit #(8) b);
      return a - b;
   endmethod
endmodule

// Bug 2: wrong whenever the two inputs are equal.
(* synthesize *)
module mkBad2 (AbsDiff_IFC);
   method Bit #(8) absdiff (Bit #(8) a, Bit #(8) b);
      if (a == b) return 1;
      else        return (a >= b) ? (a - b) : (b - a);
   endmethod
endmodule

// Bug 3: wrong for exactly one input pair out of 65536.
(* synthesize *)
module mkBad3 (AbsDiff_IFC);
   method Bit #(8) absdiff (Bit #(8) a, Bit #(8) b);
      if ((a == 0) && (b == 255)) return 0;
      else return (a >= b) ? (a - b) : (b - a);
   endmethod
endmodule

endpackage
