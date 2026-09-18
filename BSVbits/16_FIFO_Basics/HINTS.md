# Hints — 16

---

### Hint 1 — the shape

```bsv
FIFOF #(Bit #(8)) inF  <- mkFIFOF;
FIFOF #(Bit #(8)) outF <- mkFIFOF;
```

`import FIFOF :: *;` is already at the top of the file.

---

### Hint 2 — the rule

`first` reads, `deq` removes. Both, then enqueue the transformed value:

```bsv
rule move;
   let x = inF.first;
   inF.deq;
   outF.enq (x + 1);
endrule
```

No condition on the rule. The FIFOs' own guards supply it — this rule cannot fire
unless `inF` has something and `outF` has room.

---

### Hint 3 — enq and deq

Straight through. The guards come from the FIFOs:

```bsv
method Action enq (Bit #(8) x);
   inF.enq (x);
endmethod
```

You do **not** write `if (inF.notFull)`. Calling `inF.enq` is enough — its guard
becomes your method's guard automatically.

---

### Hint 4 — deq

```bsv
method ActionValue #(Bit #(8)) deq ();
   outF.deq;
   return outF.first;
endmethod
```

Order inside the method does not matter; `outF.first` still reads the head.

---

### Hint 5 — the status methods

`notFull` refers to the input side, `notEmpty` to the output side:

```bsv
method Bool notFull ()  = inF.notFull;
method Bool notEmpty () = outF.notEmpty;
```
