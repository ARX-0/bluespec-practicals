# Hints — 14

---

### Hint 1 — try it without the proviso first

Write the body, compile, and read the error. It will say something close to:

```
The proviso Bits#(t, sz) is needed but not provided
```

That is `bsc` telling you the exact line to add. Meeting this error deliberately is
worth more than avoiding it.

---

### Hint 2 — the storage

```bsv
Vector #(n, Reg #(t)) rs <- replicateM (mkReg (unpack (0)));
```

`n` and `t` are the module's own parameters — you use them just like concrete types.
`unpack(0)` is the all-zeros value of whatever `t` is.

---

### Hint 3 — the proviso

Goes between the module header and the semicolon:

```bsv
module mkBank (Bank_IFC #(n, t))
   provisos (Bits #(t, sz));
```

`sz` appears from nowhere — the proviso introduces it. You will not need to use it.

---

### Hint 4 — the methods

Just indexing. The index type already has the right width, so nothing to convert:

```bsv
method Action upd (Bit #(TLog #(n)) idx, t v);
   rs[idx] <= v;
endmethod

method t sub (Bit #(TLog #(n)) idx);
   return rs[idx];
endmethod
```

---

### Hint 5 — instantiating in mkTop

```bsv
Bank_IFC #(8, Bit #(8)) bytes <- mkBank;
Bank_IFC #(4, Pair)     pairs <- mkBank;
```

You do not pass 8 or `Bit#(8)` as arguments — they are in the interface type on the
left, and `bsc` infers what `mkBank` must elaborate to. Then the four `mkTop`
methods are one-liners calling `bytes.upd`, `bytes.sub`, `pairs.upd`, `pairs.sub`.
