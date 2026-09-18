# Solution — 05

Only if dire.

---

```bsv
   function Bit #(4) addBit (Bit #(4) acc, Bit #(1) b) = acc + zeroExtend (b);
   function Bit #(8) plus1  (Bit #(8) a) = a + 1;

   method Bit #(4) popcount (Bit #(8) x);
      Vector #(8, Bit #(1)) bits = unpack (x);
      return foldl (addBit, 0, bits);
   endmethod

   method Bit #(8) reverseBits (Bit #(8) x);
      Vector #(8, Bit #(1)) bits = unpack (x);
      return pack (Vector::reverse (bits));
   endmethod

   method Bit #(8) maxOf (Vector #(4, Bit #(8)) v);
      return foldl1 (max, v);
   endmethod

   method Vector #(4, Bit #(8)) incAll (Vector #(4, Bit #(8)) v);
      return map (plus1, v);
   endmethod
```

## Why it is written this way

**Compare with `.check/Ref.bsv`.** The reference does all four with explicit `for`
loops and index arithmetic. Both versions elaborate to *identical hardware* — check
it with `Run -v` if you like. The difference is entirely in what the source says.
`foldl (addBit, 0, bits)` states that popcount is a sum; `for (i = 0; i < 8; i = i+1)
if (x[i] == 1) c = c + 1;` states a procedure from which you must infer that.

**`foldl` vs `foldl1`.** `foldl` needs a starting accumulator, which is right for a
sum (start at 0). `foldl1` starts from element 0, which is right for max — there is
no `Bit#(8)` value that means "smaller than everything". Using `foldl (max, 0, v)`
would happen to work for unsigned bytes, and would be a bug the day the element type
becomes signed.

**`max` passed as an argument.** No wrapper, no lambda — `max` is already a function
of the right shape, so it goes straight in. Higher-order functions are how BSV builds
reusable structure; `foldl1(max, ...)` and `foldl1(min, ...)` differ by one token.

**`Vector::reverse` qualified.** There is also a `reverse` for `Bit#(n)`. Both are in
scope and `bsc` cannot choose, so name the package.

**`zeroExtend` inside `addBit`.** The accumulator is 4 bits and the element is 1 bit;
BSV will not widen for you (problem 03). The widening lives in the combining function
where it belongs.

## What to take forward

**None of this is a run-time loop.** `map`, `foldl`, `Integer` counters and
`for` loops over `Integer` are all *static elaboration* — `bsc` runs them at compile
time and emits flat logic. They cost nothing, they are not sequential, and they do
not consume cycles. When you write `map` over a 4-element vector you are telling the
compiler to instantiate four copies of something.

Keep the two ideas separate in your head from here on:

- **compile-time**: `Integer`, `for`, `map`, `foldl`, module instantiation — happens
  once, in `bsc`, and produces structure.
- **run-time**: `Bit#(n)`, registers, rules, methods — happens every cycle, in silicon.

Confusing the two is the most common source of "why won't this compile" in BSV, and
the error message is usually `bsc` telling you an `Integer` cannot be hardware.
