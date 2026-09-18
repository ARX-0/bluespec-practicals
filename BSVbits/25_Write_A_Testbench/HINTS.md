# Hints — 25

---

### Hint 1 — what the tester has to do

Drive `dut.absdiff(x, y)` with lots of `(x, y)`, compare against your own
independently-computed expected value, and remember whether you ever saw a mismatch:

```bsv
Reg #(Bool) ok  <- mkReg (True);
Reg #(Bool) fin <- mkReg (False);
```

`passed` is `ok`; `done` is `fin`. Never set `ok` back to True once it is False.

---

### Hint 2 — how many inputs

Think about how large the input space actually is. Two 8-bit inputs is 65536 pairs
— a simulator does that in milliseconds.

If you are reaching for a random number generator, ask yourself what it buys you here
over simply trying everything.

---

### Hint 3 — counter width

To loop `a` from 0 to 255 you need the counter to reach 256 so the loop can end:

```bsv
Reg #(Bit #(9)) a <- mkReg (0);
...
while (a < 256) ...
Bit #(8) x = truncate (a);
```

With `Bit#(8)`, `a < 256` is always true and the loop never terminates.

---

### Hint 4 — mkFSM, not mkAutoFSM

`mkAutoFSM` calls `$finish` when it completes, ending the whole simulation — and
there are four copies of your tester running at once. Use `mkFSM` plus a rule to
start it:

```bsv
FSM fsm <- mkFSM (prog);

Reg #(Bool) started <- mkReg (False);
rule kick (! started);
   fsm.start;
   started <= True;
endrule
```

---

### Hint 5 — the nested loop

Reset the inner counter at the top of each outer iteration:

```bsv
while (a < 256) seq
   action b <= 0; endaction
   while (b < 256) seq
      action
         ... test (a, b) ...
         b <= b + 1;
      endaction
   endseq
   action a <= a + 1; endaction
endseq
```

---

### Hint 6 — the expected value

Compute it from the specification, not from what you guess the DUT does:

```bsv
Bit #(8) exp = (x >= y) ? (x - y) : (y - x);
```

---

### Hint 7 — if you pass 3 of 4

You accepted a broken module. Read which one the message names. If it says "wrong for
exactly ONE input pair", your test was not exhaustive.
