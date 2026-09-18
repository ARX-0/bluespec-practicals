# Hints — 21

---

### Hint 1 — the state

```bsv
Reg #(Bit #(8))    n_r  <- mkReg (0);
Reg #(Bit #(8))    i    <- mkReg (0);
Reg #(Bit #(16))   acc  <- mkReg (0);
FIFOF #(Bit #(16)) outQ <- mkFIFOF;
```

`acc` is 16 bits — the sum for n = 255 is 32385, which does not fit in 8.

---

### Hint 2 — the shape of the program

```bsv
Stmt prog =
   seq
      action
         acc <= 0;
         i   <= 0;
      endaction
      while (i < n_r) seq
         action
            acc <= acc + zeroExtend (i);
            i   <= i + 1;
         endaction
      endseq
      outQ.enq (acc);
   endseq;

FSM fsm <- mkFSM (prog);
```

Each `action` block is one clock cycle.

---

### Hint 3 — why the enq is a separate step

`outQ.enq (acc)` is its own statement in the `seq`, so it happens the cycle *after*
the loop ends. By then the last `acc <= ...` has landed. Folding it into the loop's
`action` would enqueue a value one addition short.

---

### Hint 4 — start

Guard it on the FSM being idle, then set up and go:

```bsv
method Action start (Bit #(8) n) if (fsm.done);
   n_r <= n;
   fsm.start;
endmethod
```

Setting `n_r` in the same cycle as `fsm.start` is fine — the FSM's first action runs
the *next* cycle, by which time `n_r` has landed.

---

### Hint 5 — mkFSM, not mkAutoFSM

`mkAutoFSM` runs once at power-on and calls `$finish` at the end, killing the
simulation. You want `mkFSM`, which waits for `fsm.start`.

---

### Hint 6 — the rest

```bsv
method Bool busy () = ! fsm.done;

method ActionValue #(Bit #(16)) result ();
   outQ.deq;
   return outQ.first;
endmethod
```
