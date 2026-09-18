// ============================================================================
// 15 -- Typeclasses: writing your own instances
//
// >>> THIS IS THE FILE YOU EDIT. <<<
//
// You have been USING typeclasses since problem 04 -- `deriving (Bits, Eq,
// FShow)` asks bsc to write instances for you. Here you write them yourself.
//
// The three methods of mkTop are already finished. They all just call
// `score`. Your job is to make `score` exist for three different types.
// ============================================================================

package Top;

import Vector :: *;

// ---------------------------------------------------------------------------
// The class. One function, overloaded on the type of its argument.
// ---------------------------------------------------------------------------
typeclass Scorable #(type t);
   function Bit #(16) score (t x);
endtypeclass

typedef enum { Clubs, Diamonds, Hearts, Spades }
   Suit deriving (Bits, Eq, FShow);

typedef struct {
   Suit     suit;
   Bit #(4) rank;
} Card deriving (Bits, Eq, FShow);

// ---------------------------------------------------------------------------
// TODO: write three instances.
//
//   1. Scorable #(Bit #(8))
//         score (x) = x, widened to 16 bits.
//
//   2. Scorable #(Card)
//         score (c) = rank + 100 * (suit as a number, Clubs = 0 .. Spades = 3)
//
//   3. Scorable #(Vector #(n, t))  for ANY n and ANY scorable t
//         score (v) = the sum of the scores of the elements.
//         This one needs a proviso saying t is itself Scorable.
//
// The shape of an instance:
//
//    instance Scorable #(SomeType);
//       function Bit #(16) score (SomeType x);
//          return ...;
//       endfunction
//    endinstance
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Do not change anything below this line.
// ---------------------------------------------------------------------------

interface Score_IFC;
   method Bit #(16) scoreByte (Bit #(8) x);
   method Bit #(16) scoreCard (Card c);
   method Bit #(16) scoreHand (Vector #(3, Card) h);
endinterface

(* synthesize *)
module mkTop (Score_IFC);

   method Bit #(16) scoreByte (Bit #(8) x)          = score (x);
   method Bit #(16) scoreCard (Card c)              = score (c);
   method Bit #(16) scoreHand (Vector #(3, Card) h) = score (h);

endmodule

endpackage
