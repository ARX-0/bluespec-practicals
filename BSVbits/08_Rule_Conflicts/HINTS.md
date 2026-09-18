# Hints — 08

---

### Hint 1 — read the failure first

Did you run it before editing? Do that. The output says:

```
FIRST MISMATCH at cycle 10: count exp 0 got 10
...
bsc also warned about the SCHEDULE -- this is very likely your bug:
   Rule "do_incr" was treated as more urgent than "do_reset"
   According to the generated schedule, rule `do_reset' can never fire.
```

`do_reset` never fires. Ask yourself why an unconditional rule always beating a
conditional one would cause that.

---

### Hint 2 — why do_reset starves

`do_incr` has no condition, so it is ready on every single cycle. `bsc` broke the
tie by source order, and `do_incr` is written first. It therefore wins every cycle,
forever, and `do_reset` is dead code.

You need to tell `bsc` that the reset is the more important of the two.

---

### Hint 3 — the attribute

BSV attributes are written in `(* ... *)` and sit immediately above what they apply
to. The one you want names the rules in order of decreasing urgency:

```bsv
(* descending_urgency = "<more urgent>, <less urgent>" *)
```

---

### Hint 4 — placement

Put it directly above the first of the two rules. The names inside the string are
the rule names, most urgent first, comma-separated, in quotes.

You do not need to change any other line in the file.

---

### Hint 5 — near-code

```bsv
(* descending_urgency = "do_reset, do_incr" *)
rule do_incr;
   ...
```
