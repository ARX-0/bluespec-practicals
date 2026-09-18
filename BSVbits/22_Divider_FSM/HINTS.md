# Hints — 22

---

### Hint 1 — the state

```bsv
Reg #(Bit #(16))   quo   <- mkReg (0);
Reg #(Bit #(16))   rem   <- mkReg (0);
Reg #(Bit #(8))    den_r <- mkReg (0);
Reg #(Bit #(5))    step  <- mkReg (16);      // 16 == idle
FIFOF #(DivResult) outQ  <- mkFIFOF;
```

`step` is 5 bits so it can hold 16.

---

### Hint 2 — start

```bsv
method Action start (Bit #(16) num, Bit #(8) den) if (step == 16);
   quo   <= num;      // the dividend starts in the quotient register
   rem   <= 0;
   den_r <= den;
   step  <= 0;
endmethod
```

The dividend goes into `quo`, not `rem`. It is shifted out of the top of `quo` and
into `rem` one bit at a time, and the quotient bits fill in behind it.

---

### Hint 3 — one iteration

Shift first, then compare:

```bsv
Bit #(16) r2 = (rem << 1) | zeroExtend (quo[15]);
Bit #(16) q2 = quo << 1;
```

`quo[15]` is the bit being shifted out of the top. Then:

```bsv
Bit #(16) d = zeroExtend (den_r);
if (r2 >= d) begin
   r2 = r2 - d;
   q2 = q2 | 1;
end
```

Note these are `=` bindings on locals, not `<=` on registers — so the `if` can refine
them within the cycle.

---

### Hint 4 — the last step

On step 15 you have the finished values in `r2` and `q2`, but they have not been
written to the registers yet. Publish the locals directly:

```bsv
if (step == 15) begin
   outQ.enq (DivResult { quo: q2, rem: r2 });
   step <= 16;
end
else begin
   quo <= q2;  rem <= r2;  step <= step + 1;
end
```

Enqueueing `quo`/`rem` here instead of `q2`/`r2` gives you the values from *before*
the last iteration.

---

### Hint 5 — if it times out

Check that `step` gets back to 16. If the rule's guard is `step <= 16` rather than
`step < 16`, it fires forever and `start` is never ready again.
