# Hints — 05

---

### Hint 1 — get to a Vector first

Three of these four methods take or return a `Bit#(8)`, but the interesting
operations live on `Vector`. The bridge is `unpack` / `pack`:

```bsv
Vector #(8, Bit #(1)) bits = unpack (x);
```

Now `bits` is something `map`, `foldl` and `reverse` can work on.

---

### Hint 2 — helper functions

Define small named functions inside the module, above the methods:

```bsv
function Bit #(8) plus1 (Bit #(8) a) = a + 1;
```

Then `map (plus1, v)`. `incAll` is now one line.

---

### Hint 3 — popcount is a fold

You are collapsing 8 bits into one number, carrying a running total. That is
`foldl` with a starting accumulator of `0`.

The accumulator is `Bit#(4)` and the elements are `Bit#(1)`, so your combining
function has to widen the bit before adding it — `zeroExtend`.

---

### Hint 4 — maxOf

There is no useful "starting value" for a maximum, so use `foldl1`, which begins
with the vector's first element.

And you do not need to write the combining function: `max` already exists.

---

### Hint 5 — reverseBits

`Vector::reverse` on the unpacked bits, then `pack` the result. Write the
`Vector::` qualifier — bare `reverse` is ambiguous.

---

### Hint 6 — near-code

```bsv
function Bit #(4) addBit (Bit #(4) acc, Bit #(1) b) = acc + zeroExtend (b);

method Bit #(4) popcount (Bit #(8) x);
   Vector #(8, Bit #(1)) bits = unpack (x);
   return foldl (addBit, 0, bits);
endmethod
```
