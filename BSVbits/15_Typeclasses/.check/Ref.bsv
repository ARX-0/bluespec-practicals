// Golden reference for problem 15 -- specification, not solution.
// Three separate, differently-named functions and no typeclass anywhere.
// This is the "just write three functions" answer: it works, and it is what
// you have to do in a language without overloading.
package Ref;
import Top    :: *;
import Vector :: *;

(* synthesize *)
module mkRef (Score_IFC);

   function Bit #(16) byteScore (Bit #(8) x);
      return { 8'b0, x };
   endfunction

   function Bit #(16) cardScore (Card c);
      Bit #(16) suitNum = case (c.suit)
                             Clubs:    0;
                             Diamonds: 1;
                             Hearts:   2;
                             Spades:   3;
                          endcase;
      return zeroExtend (c.rank) + (100 * suitNum);
   endfunction

   function Bit #(16) handScore (Vector #(3, Card) h);
      Bit #(16) t = 0;
      for (Integer i = 0; i < 3; i = i + 1)
         t = t + cardScore (h[i]);
      return t;
   endfunction

   method Bit #(16) scoreByte (Bit #(8) x)          = byteScore (x);
   method Bit #(16) scoreCard (Card c)              = cardScore (c);
   method Bit #(16) scoreHand (Vector #(3, Card) h) = handScore (h);

endmodule

endpackage
