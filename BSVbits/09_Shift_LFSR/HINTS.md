# Hints — 09

---

### Hint 1 — the LFSR register

Seeded to `0xFF`, so the reset value is not 0:

```bsv
Reg #(Bit #(8)) s <- mkReg (8'hFF);
```

An LFSR seeded to 0 stays 0 forever, which is why the seed matters.

---

### Hint 2 — the shift

Compute the feedback bit, then concatenate:

```bsv
Bit #(1) nb = s[7] ^ s[5] ^ s[4] ^ s[3];
s <= { s[6:0], nb };
```

`s[6:0]` is 7 bits, `nb` is 1, total 8. Widths line up.

---

### Hint 3 — the delay line

```bsv
Vector #(3, Reg #(Bit #(1))) dl <- replicateM (mkReg (0));
```

Note `<-`, not `=`. `replicateM` is instantiating three register modules, and
instantiation is an action.

---

### Hint 4 — shifting the line

Stage 0 takes the new input; each later stage takes the one before it. Order does
not matter — these are non-blocking writes, so every right-hand side sees the old
value:

```bsv
dl[0] <= s[0];
dl[1] <= dl[0];
dl[2] <= dl[1];
```

Or as a static loop, which is what you would write for a longer line:

```bsv
for (Integer i = 1; i < 3; i = i + 1)
   dl[i] <= dl[i - 1];
```

---

### Hint 5 — "sampled before the shift"

`s[0]` inside the rule already *is* the pre-shift value — `<=` means the new `s`
does not exist until the clock edge. Put both writes in the same rule and it just
works.

---

### Hint 6 — the output

`delayed3` is the last stage: `dl[2]`.
