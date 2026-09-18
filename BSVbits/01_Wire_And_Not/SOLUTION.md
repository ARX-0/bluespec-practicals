# Solution — 01

Only if dire.

---

```bsv
method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
   return ~(a & b);
endmethod

method Bit #(1) nor2 (Bit #(1) a, Bit #(1) b);
   return ~(a | b);
endmethod

method Bit #(1) xnor2 (Bit #(1) a, Bit #(1) b);
   return ~(a ^ b);
endmethod

method Bit #(1) mux2 (Bit #(1) sel, Bit #(1) a, Bit #(1) b);
   return (sel == 0) ? a : b;
endmethod
```

## Why it is written this way

**`~(a & b)` rather than a truth table.** The reference module in `.check/Ref.bsv`
deliberately writes these as comparisons (`((a == 1) && (b == 1)) ? 0 : 1`) — that is
the *specification*, and it is correct, but it is not how you would describe a gate.
Both compile to identical hardware. Getting used to writing the structural form is
worth doing now, because from problem 05 onward the expression form is the only one
that scales.

**`(sel == 0) ? a : b` rather than `sel ? a : b`.** BSV's `?:` requires a `Bool`
condition. `sel` is a `Bit#(1)`, which is a one-element vector of bits, not a truth
value. The compiler will not convert for you. You will meet this distinction
constantly — `Bool` for control, `Bit#(n)` for data — and BSV keeps them apart on
purpose.

**Why the mux could also be `(~sel & a) | (sel & b)`.** Identical hardware. Use
whichever reads better; `bsc` optimises both to the same thing. Check for yourself
with `Run -v` and look at `outputs/verilog/mkTop.v`.

## What to take forward

Value methods are combinational logic and nothing more. The moment you want state,
you need a register and a `rule` — which is problem 06, and where BSV stops looking
like Verilog with different syntax.
