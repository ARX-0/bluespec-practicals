# Hints — 13

---

### Hint 1 — the state

```bsv
Vector #(4, Reg #(Bit #(8))) data <- replicateM (mkReg (0));
Reg #(Bit #(2)) head <- mkReg (0);   // next slot to read
Reg #(Bit #(2)) tail <- mkReg (0);   // next slot to write
Reg #(Bit #(3)) cnt  <- mkReg (0);   // how many items
```

`head` and `tail` are 2 bits so they wrap automatically. `cnt` needs **3** bits —
it goes up to 4, which does not fit in 2.

---

### Hint 2 — the guard syntax

After the argument list, before the semicolon:

```bsv
method Action enq (Bit #(8) x) if (cnt < 4);
```

For `deq`, the condition goes in the same place even though it takes no arguments:

```bsv
method ActionValue #(Bit #(8)) deq () if (cnt > 0);
```

---

### Hint 3 — enq

Write at `tail`, advance `tail`, count up. The dynamic index works directly:

```bsv
data[tail] <= x;
tail <= tail + 1;
cnt  <= cnt + 1;
```

No masking needed — `tail` is `Bit#(2)`, so `3 + 1` is `0`.

---

### Hint 4 — deq

Mirror image: return what is at `head`, advance `head`, count down.

```bsv
head <= head + 1;
cnt  <= cnt - 1;
return data[head];
```

`return data[head]` reads the old `head`, which is the one you want — `<=` has not
landed yet.

---

### Hint 5 — if the run times out

A timeout means one of your guards is never true, so the testbench's rule can never
fire. Check them: `enq` should be ready when `cnt < 4`, `deq` when `cnt > 0`. Getting
these backwards, or writing `cnt <= 4` instead of `cnt < 4`, produces exactly this.

---

### Hint 6 — the status methods

```bsv
method Bool     notFull ()  = (cnt < 4);
method Bool     notEmpty () = (cnt > 0);
method Bit #(3) depth ()    = cnt;
```

Note these are the same expressions as the guards. That is normal.
