# Solution — 15

Only if dire.

---

```bsv
instance Scorable #(Bit #(8));
   function Bit #(16) score (Bit #(8) x);
      return zeroExtend (x);
   endfunction
endinstance

instance Scorable #(Card);
   function Bit #(16) score (Card c);
      Bit #(16) suitNum = zeroExtend (pack (c.suit));
      return zeroExtend (c.rank) + (100 * suitNum);
   endfunction
endinstance

instance Scorable #(Vector #(n, t))
   provisos (Scorable #(t));
   function Bit #(16) score (Vector #(n, t) v);
      function Bit #(16) addOne (Bit #(16) acc, t e) = acc + score (e);
      return foldl (addOne, 0, v);
   endfunction
endinstance
```

## Why it is written this way

**`pack (c.suit)` instead of a `case`.** `Suit` derives `Bits`, which is exactly a
`Scorable`-shaped decision someone already made: the enum's binary encoding is its
declaration order. `.check/Ref.bsv` writes the four-arm `case` out longhand, and it
is correct, but it duplicates a mapping the `deriving` clause already established —
so reordering the enum would silently desynchronise the two.

**The vector instance is the whole point.** `provisos (Scorable #(t))` makes it
conditional: *vectors of scorable things are scorable*. One instance now covers
`Vector#(3, Card)`, `Vector#(52, Card)`, `Vector#(8, Bit#(8))`, and
`Vector#(2, Vector#(3, Card))` — that last one resolving through itself twice,
because the inner `score(e)` finds the vector instance again.

Without the proviso, `score(e)` inside `addOne` will not compile: `bsc` has no
reason to believe an arbitrary `t` has an instance. The error message says so
directly, and it is a good one to have read.

**`addOne` defined inside `score`.** It closes over nothing, but it needs to be in
scope where `t` is bound, and defining it locally keeps it out of the global
namespace. This nested one-line `function ... = expr;` form is common in BSV.

**`foldl` and not a `for` loop.** Same argument as problem 05, with an extra edge
here: the vector's length is `n`, a type parameter. A `for` loop would need
`valueOf(n)` for its bound; `foldl` just works at any length. Generic code pushes
you toward the folds whether you like them or not.

**All of this is compile-time.** `bsc` resolves every `score` call to a concrete
function during elaboration and inlines it. There is no dispatch, no vtable, no
indirection — the generated Verilog for `scoreHand` is three multipliers and two
adders. Typeclasses are a source-level structuring tool with zero hardware cost.

## What to take forward

You have now met both halves of BSV's abstraction machinery, and they are the same
machinery:

- **problem 14** — a *module* generic over a type, with a proviso saying what it
  needs of that type (`Bits#(t, sz)`)
- **problem 15** — a *function* generic over a type, with instances saying how it
  behaves per type

Provisos are the join: `Bits#(t, sz)` in a module header and `Scorable#(t)` in an
instance header are the same kind of constraint, and both are checked where the
generic thing is used.

This is why `deriving (Bits, Eq, FShow)` appears on essentially every type
definition in real BSV. Each clause buys entry to a set of generic components:
`Bits` lets the type go in a register, a FIFO, or across a bus; `Eq` lets it be
compared; `FShow` makes it printable. When you define an AXI transaction struct
later, that one line is what lets the entire library carry it.
