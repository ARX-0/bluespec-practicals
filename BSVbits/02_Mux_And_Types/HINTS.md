# Hints — 02

---

### Hint 1 — mux4

`case` is an expression in BSV. You can `return` it. Remember `default`.

---

### Hint 2 — swapNibbles

Exactly the Verilog: concatenate the low nibble and the high nibble in the other
order. Braces, comma-separated.

---

### Hint 3 — ugt

`Bit#(n)` already compares as unsigned. This method is one short expression and
needs no conversion at all.

---

### Hint 4 — sgt

This is the one that needs work. The bits mean something different, so tell BSV
what they mean:

```bsv
Int #(8) ia = unpack (a);
```

do the same for `b`, and then just use `>`. The comparison operator picks its
behaviour from the type.

---

### Hint 5 — near-code

```bsv
method Bool sgt (Bit #(8) a, Bit #(8) b);
   Int #(8) ia = unpack (a);
   Int #(8) ib = unpack (b);
   return ia > ib;
endmethod
```
