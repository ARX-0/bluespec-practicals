# Hints — 07

---

### Hint 1 — three registers, three rules

Same shape as problem 06, but each rule gets a condition. Note the reset values
differ: `up` starts at 0, `down` starts at **100**, `slow` starts at 0.

```bsv
Reg #(Bit #(8)) d <- mkReg (100);
```

---

### Hint 2 — the guard syntax

The condition goes in parentheses after the rule name:

```bsv
rule count_up (u < 200);
   u <= u + 1;
endrule
```

No `if` inside. If the condition is false, the rule simply does not fire and `u`
keeps its value — which is exactly "saturate".

---

### Hint 3 — down

Same idea, mirrored. It must stop *at* 0, so the rule may only fire while the
value is still above 0. Think about whether `d > 0` or `d >= 0` is right — one of
them lets the counter wrap around to 255.

---

### Hint 4 — slow

The condition is on a *different* register from the one being written. That is
fine and completely normal:

```bsv
rule count_slow (u < 50);
   s <= s + 1;
endrule
```

---

### Hint 5 — near-code

```bsv
Reg #(Bit #(8)) u <- mkReg (0);

rule count_up (u < 200);
   u <= u + 1;
endrule

method Bit #(8) up = u;
```
