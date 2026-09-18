# Solution — 06

Only if dire.

---

```bsv
   Reg #(Bit #(8)) count_r   <- mkReg (0);
   Reg #(Bit #(8)) delayed_r <- mkReg (0);
   Reg #(Bit #(8)) evens_r   <- mkReg (0);

   rule tick;
      count_r   <= count_r + 1;
      delayed_r <= count_r;
   endrule

   rule bump_evens (count_r[0] == 0);
      evens_r <= evens_r + 1;
   endrule

   method Bit #(8) count   = count_r;
   method Bit #(8) delayed = delayed_r;
   method Bit #(8) evens   = evens_r;
```

## Why it is written this way

**`delayed_r <= count_r` in the same rule as the increment.** This is the one place
where BSV's semantics match Verilog's exactly and it is worth naming: `<=` is a
non-blocking write, so `count_r` on the right-hand side is the value *before* this
cycle's update. Both writes are computed from old state and land together. If `<=`
behaved like a blocking assignment, `delayed_r` would get the incremented value and
the delay would vanish.

**Two rules rather than one.** `bump_evens` is a separate rule with a condition,
which reads more directly than an `if` buried in `tick`. Here the two are
equivalent — `bsc` generates identical hardware — because the rules touch disjoint
registers and can always fire together.

That equivalence is a special case, not a general truth. When two rules write the
*same* register they conflict, and the guarded form and the `if` form stop meaning
the same thing. That is problem 08.

**The `_r` suffix.** A register and a method cannot share a name in the same scope.
Suffixing the register is the common BSV convention; some people prefix the method
instead. Pick one and keep it.

**`count_r[0] == 0` rather than `!count_r[0]`.** Bit selection gives a `Bit#(1)`, and
a rule condition must be a `Bool`. The comparison produces one.

## What to take forward

The mental replacement to make right now:

| Verilog | BSV |
|---|---|
| `reg [7:0] x;` | `Reg#(Bit#(8)) x <- mkReg(0);` |
| `always @(posedge clk)` | `rule name; ... endrule` |
| `if (rst) x <= 0; else` | *nothing — it is the `mkReg` argument* |
| `x <= expr;` | `x <= expr;` (unchanged) |

The last row is why problem 06 feels easy. The next two problems are where the
correspondence breaks down, and it breaks down around *rule conditions* — which
look like `if` and are not.
