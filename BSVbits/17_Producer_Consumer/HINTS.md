# Hints — 17

---

### Hint 1 — the state

```bsv
FIFOF #(Bit #(8))  q     <- mkFIFOF;
FIFOF #(Bit #(16)) outQ  <- mkFIFOF;
Reg #(Bit #(8))    nextV <- mkReg (0);
Reg #(Bit #(2))    phase <- mkReg (0);
```

`phase` is 2 bits, so it counts 0,1,2,3,0,… on its own — that is your "every 4th
cycle".

---

### Hint 2 — the producer

```bsv
rule produce;
   q.enq (nextV);
   nextV <= nextV + 1;
endrule
```

No condition. `q.enq`'s guard stalls it when the FIFO is full, and because the rule
is atomic, `nextV` stops advancing at the same time. Keep both actions in the *same*
rule — that is what keeps them in step.

---

### Hint 3 — the phase counter

Its own rule, unconditional:

```bsv
rule tick;
   phase <= phase + 1;
endrule
```

Keep it separate from `produce`. If `produce` stalls, the phase must keep running.

---

### Hint 4 — the consumer

```bsv
rule consume (phase == 0);
   let x = q.first;
   q.deq;
   Bit #(16) w = zeroExtend (x);
   outQ.enq (w * w);
endrule
```

Widen *before* multiplying (problem 03) — `x * x` in 8 bits overflows at x = 16.

---

### Hint 5 — the interface

```bsv
method ActionValue #(Bit #(16)) result ();
   outQ.deq;
   return outQ.first;
endmethod

method Bool hasResult () = outQ.notEmpty;
```
