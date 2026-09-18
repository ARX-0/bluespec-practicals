# Hints — 03

---

### Hint 1 — the last three are one-liners

`zext`, `sext` and `trunc` are each a single library call. BSV has three functions
whose names say exactly what they do. You do not need to write any bit slicing.

---

### Hint 2 — why add8 is harder

`a + b` where both are `Bit#(8)` produces `Bit#(8)`. The carry has nowhere to live,
so it is lost before you can return it. Returning `Bit#(9)` from an 8-bit sum will
not type-check.

Fix it by making the operands 9 bits wide *before* adding.

---

### Hint 3 — widening the operands

Two ways, both fine:

```bsv
{ 1'b0, a }        // concatenate a zero bit on top
zeroExtend (a)     // same thing, width inferred
```

You need all three terms — `a`, `b`, and `cin` — at 9 bits.

---

### Hint 4 — cin

`cin` is `Bit#(1)`. It also has to become `Bit#(9)` to join the sum:
`zeroExtend(cin)`, or `{ 8'b0, cin }`.

---

### Hint 5 — near-code

```bsv
method Bit #(9) add8 (Bit #(8) a, Bit #(8) b, Bit #(1) cin);
   return zeroExtend (a) + zeroExtend (b) + zeroExtend (cin);
endmethod
```
