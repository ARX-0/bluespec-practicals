# Hints — 18

---

### Hint 1 — a stage is problem 16's module

Two FIFOs and a rule. The only new part is what you expose:

```bsv
FIFOF #(Bit #(8)) inQ  <- mkFIFOF;
FIFOF #(Bit #(8)) outQ <- mkFIFOF;

rule go;
   let x = inQ.first;
   inQ.deq;
   outQ.enq (x + 1);
endrule
```

---

### Hint 2 — exposing Get and Put

Do not write the methods out. `GetPut` has adapters:

```bsv
interface inp  = toPut (inQ);
interface outp = toGet (outQ);
```

Delete the `interface Put inp; method Action put ...` placeholder blocks entirely
and use these two lines.

---

### Hint 3 — mkTimesThree

Same shape, different types and transform. Widen before multiplying:

```bsv
Bit #(16) w = zeroExtend (x);
outQ.enq (w * 3);
```

The input FIFO holds `Bit#(8)`, the output FIFO holds `Bit#(16)`.

---

### Hint 4 — instantiating in mkTop

```bsv
Stage_IFC #(Bit #(8), Bit #(8))  a <- mkAddOne;
Stage_IFC #(Bit #(8), Bit #(16)) b <- mkTimesThree;
```

---

### Hint 5 — connecting and exposing

```bsv
mkConnection (a.outp, b.inp);

interface request  = a.inp;
interface response = b.outp;
```

`mkConnection` sits at module level like any other instantiation — it is a module
that contains a rule. And the last two lines just hand the outer ends straight
through; there is nothing to implement.
