# Hints — 11

---

### Hint 1 — why not just a register

If `produce` writes a register and `consume` reads it, `consume` sees the value one
cycle late, and `last` lags `hits` by a cycle. The checker compares every cycle, so
that fails. You need same-cycle transfer, which means a wire.

---

### Hint 2 — declaring it

```bsv
RWire #(Bit #(8)) pulse <- mkRWire;
```

No reset value — it holds nothing between cycles.

---

### Hint 3 — the producing rule

The pulse condition is on the *current* tick, so guard the rule with it:

```bsv
rule produce (tick_r[1:0] == 0);
   pulse.wset (tick_r);
endrule
```

---

### Hint 4 — the consuming rule

`pulse.wget` is a `Maybe#(Bit#(8))`. Guard on it being valid, then extract:

```bsv
rule consume (isValid (pulse.wget));
   hits_r <= hits_r + 1;
   last_r <= fromMaybe (0, pulse.wget);
endrule
```

`fromMaybe(default, m)` returns the payload, or the default when `Invalid`. Here
the guard already guarantees it is valid, so the default is never used.

---

### Hint 5 — why mkRWire and not mkDWire

`mkDWire(0)` would read as `0` when no pulse occurred — indistinguishable from a
real pulse at `tick == 0`, which is the very first pulse. You need the
`Valid`/`Invalid` distinction.

---

### Hint 6 — the third rule

`tick_r <= tick_r + 1` needs its own rule. Keep it separate: `produce` reads
`tick_r`, so the reader-before-writer ordering stays consistent (this is the same
constraint you met in problem 10).
