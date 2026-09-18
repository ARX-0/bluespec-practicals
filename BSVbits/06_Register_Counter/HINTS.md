# Hints — 06

---

### Hint 1 — three registers

You need state, and state in BSV is a register module you instantiate inside the
module body, above the methods:

```bsv
Reg #(Bit #(8)) count_r <- mkReg (0);
```

The `0` is the reset value. Do all three.

Name them differently from the methods — `count_r`, not `count` — or the names
collide.

---

### Hint 2 — the rule

Registers do not update themselves. Add a rule:

```bsv
rule tick;
   count_r <= count_r + 1;
endrule
```

A rule with no condition fires every cycle, which is what you want for `count`.

---

### Hint 3 — delayed, for free

`<=` is a non-blocking write: reads in this cycle see the *old* value. So inside
the same rule,

```bsv
count_r   <= count_r + 1;
delayed_r <= count_r;
```

gives `delayed_r` the pre-increment value. Exactly as in Verilog. No extra logic.

---

### Hint 4 — evens

This one only updates on some cycles. Two ways:

```bsv
rule bump_evens (count_r[0] == 0);      // a guarded rule
   evens_r <= evens_r + 1;
endrule
```

or an `if` inside the main rule. Both work here and produce the same hardware.
Problem 07 is about when they stop being the same.

Remember `count_r[0]` is a `Bit#(1)`, so compare it: `== 0`.

---

### Hint 5 — the methods

Once the registers hold the right values, the methods just expose them:

```bsv
method Bit #(8) count = count_r;
```
