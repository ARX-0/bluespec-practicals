# Hints — 01

Read one at a time. Stop as soon as you are unstuck.

---

### Hint 1 — the shape

You are not writing any new structure. The four `method ... endmethod` blocks are
already in `Top.bsv`; only the `return 0;` lines are wrong. Replace each with the
right expression.

---

### Hint 2 — the operators

BSV's bitwise operators are Verilog's: `&` (and), `|` (or), `^` (xor), `~` (not).
They work directly on `Bit#(1)`.

So "NOT (a AND b)" is written exactly the way it reads.

---

### Hint 3 — the mux

Two ways, both fine:

```bsv
return (sel == 0) ? a : b;      // conditional expression
```

or, if you prefer the gate-level form, `(~sel & a) | (sel & b)`.

Note you must write `sel == 0`, not `if (sel)` — `sel` is a `Bit#(1)`, and BSV will
not silently treat a 1-bit vector as a `Bool`. This strictness is the point; it is
also the single most common thing to trip on in your first hour of BSV.

---

### Hint 4 — near-code

```bsv
method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
   return ~(a & b);
endmethod
```

The other three follow the same pattern.
