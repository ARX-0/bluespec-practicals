# Hints — 10

---

### Hint 1 — the CReg

```bsv
Reg #(Bit #(8)) cnt [2] <- mkCReg (2, 0);
```

Note the `[2]` on the left — you are declaring an *array* of two `Reg` interfaces
onto one piece of state. `tot` and `phase` stay ordinary `mkReg`s.

---

### Hint 2 — which port goes where

The increment must happen *first* and the drain must *see* it. Port 0 is earlier,
port 1 is later:

- `do_incr` writes `cnt[0]`
- `do_drain` reads and writes `cnt[1]`

`do_drain` reading `cnt[1]` gets the value `do_incr` just wrote, this cycle. Its
write to `cnt[1]` is the one that lands.

---

### Hint 3 — if bsc says "do_drain can never fire"

You have asked for two contradictory orderings, and this is worth understanding
rather than working around.

The `CReg` says: `do_incr` (port 0) is before `do_drain` (port 1).

But if `do_incr` also writes `phase` and `do_drain` *reads* `phase`, that says the
opposite — a reader of a plain register must be scheduled before its writer, since
reads see the start-of-cycle value. `bsc` cannot satisfy both, so it drops one rule.

---

### Hint 4 — the fix

Give the phase counter its own rule, so nothing that `do_drain` reads is written by
`do_incr`:

```bsv
rule do_phase;
   phase <= phase + 1;
endrule
```

Now the order `do_incr → do_drain → do_phase` satisfies everything.

---

### Hint 5 — near-code

```bsv
rule do_incr;
   cnt[0] <= cnt[0] + 1;
endrule

rule do_drain (phase == 3);
   tot    <= tot + cnt[1];
   cnt[1] <= 0;
endrule
```

`current` is `cnt[0]` (the start-of-cycle view).
