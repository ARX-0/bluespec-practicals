# Solution — 03

Only if dire.

---

```bsv
method Bit #(9) add8 (Bit #(8) a, Bit #(8) b, Bit #(1) cin);
   return { 1'b0, a } + { 1'b0, b } + { 8'b0, cin };
endmethod

method Bit #(16) zext (Bit #(8) x);
   return zeroExtend (x);
endmethod

method Bit #(16) sext (Bit #(8) x);
   return signExtend (x);
endmethod

method Bit #(8) trunc (Bit #(16) x);
   return truncate (x);
endmethod
```

`add8` is equally correct as:

```bsv
return zeroExtend (a) + zeroExtend (b) + zeroExtend (cin);
```

## Why it is written this way

**The widening has to happen before the `+`, not after.** This is the whole
problem. `Bit#(8) + Bit#(8) = Bit#(8)`; there is no context in which BSV silently
gives you a ninth bit. Writing `zeroExtend(a + b)` compiles and is *wrong* — it
extends the already-truncated 8-bit sum, and the carry is gone. Widen the operands,
then add.

**Why `zeroExtend` for `cin` and not `signExtend`.** `cin` is a carry, not a signed
number; sign-extending `1'b1` would give all ones. Whenever both would compile, the
one that matches the meaning of the value is the right one.

**Why the library functions instead of concatenation.** `zeroExtend(x)` works at any
width; `{8'b0, x}` only works when the target is exactly 16. The moment the design
becomes parameterised (problem 14) the hardcoded form stops compiling and the
library form keeps working unchanged.

## What to take forward

The rule is: **BSV never changes a width behind your back.** Every widening and
narrowing in a BSV design is something a person typed. That is more keystrokes than
Verilog and dramatically fewer late-night waveform sessions.

If `bsc` says it cannot infer a width for a `zeroExtend`, it means the result is not
flowing anywhere with a known type yet. Bind it to an annotated variable:

```bsv
Bit #(16) w = zeroExtend (x);
```
