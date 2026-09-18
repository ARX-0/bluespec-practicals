# Hints — 19

---

### Hint 1 — four FIFOs, three rules

One FIFO at the input, one after each stage. The types change as the data widens:

```bsv
FIFOF #(Bit #(8))  q0 <- mkFIFOF;   // input
FIFOF #(Bit #(8))  q1 <- mkFIFOF;   // after +1
FIFOF #(Bit #(16)) q2 <- mkFIFOF;   // after *3
FIFOF #(Bit #(16)) q3 <- mkFIFOF;   // after ^0xAAAA
```

---

### Hint 2 — each stage is the same three lines

```bsv
rule stage1;
   let x = q0.first;
   q0.deq;
   q1.enq (x + 1);
endrule
```

No rule conditions anywhere. The FIFOs supply them all.

---

### Hint 3 — stage 2 widens

`q1` holds `Bit#(8)` and `q2` holds `Bit#(16)`, so widen before multiplying:

```bsv
Bit #(16) w = zeroExtend (x);
q2.enq (w * 3);
```

---

### Hint 4 — stage 1 does NOT widen

Stage 1 is `Bit#(8)` in and `Bit#(8)` out, so `x + 1` wraps at 255. That is
deliberate — the reference does the same. Do not "fix" it by widening early.

---

### Hint 5 — the methods

```bsv
method Action put (Bit #(8) x);
   q0.enq (x);
endmethod

method ActionValue #(Bit #(16)) get ();
   q3.deq;
   return q3.first;
endmethod

method Bool canPut () = q0.notFull;
method Bool canGet () = q3.notEmpty;
```

`put` touches only `q0` and `get` touches only `q3`, so nothing stops them
happening in the same cycle.
