# Hints — 20

---

### Hint 1 — the state

```bsv
Reg #(Bit #(16))   prod  <- mkReg (0);   // accumulator
Reg #(Bit #(16))   mcand <- mkReg (0);   // multiplicand, shifts LEFT
Reg #(Bit #(8))    mplr  <- mkReg (0);   // multiplier, shifts RIGHT
Reg #(Bit #(4))    step  <- mkReg (8);   // 8 = idle, 0..7 = working
FIFOF #(Bit #(16)) outQ  <- mkFIFOF;
```

`mcand` must be 16 bits — it gets shifted left up to 7 times.

`step` is 4 bits so it can hold 8, the idle marker.

---

### Hint 2 — accepting a request

Guard it on being idle, and set up the state:

```bsv
method Action put (MulReq r) if (step == 8);
   prod  <= 0;
   mcand <= zeroExtend (r.a);
   mplr  <= r.b;
   step  <= 0;
endmethod
```

---

### Hint 3 — the iteration rule

```bsv
rule iterate (step < 8);
   if (mplr[0] == 1) prod <= prod + mcand;
   mcand <= mcand << 1;
   mplr  <= mplr >> 1;
   step  <= step + 1;
endrule
```

This is *nearly* right, but see the next hint about the last step.

---

### Hint 4 — the last step

On step 7 you need the final product, but `prod <= prod + mcand` has not landed yet
— `<=` means `prod` still holds the old value this cycle. So compute the new value
into a local first, then use it:

```bsv
Bit #(16) nextProd = (mplr[0] == 1) ? prod + mcand : prod;

if (step == 7) begin
   outQ.enq (nextProd);
   step <= 8;               // back to idle
end
else begin
   prod <= nextProd;
   step <= step + 1;
end
```

---

### Hint 5 — the response

Do not write the method out. `outQ` already is a `Get`:

```bsv
interface response = toGet (outQ);
```

Its guard means `response.get` is only ready once a result exists — which is why
the result goes through a FIFO rather than being read out of `prod`.

---

### Hint 6 — if it times out

Check that `step` returns to 8. If `iterate`'s guard is `step <= 8` rather than
`step < 8`, the rule fires forever and `put` is never ready again.
