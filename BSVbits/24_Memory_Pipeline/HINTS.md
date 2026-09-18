# Hints — 24

---

### Hint 1 — the state

```bsv
BRAM_Configure cfg = defaultValue;
cfg.memorySize = 256;
BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);

FIFOF #(Bit #(8)) outQ <- mkSizedFIFOF (8);
```

---

### Hint 2 — writeMem and load are both requests

Same `BRAMRequest`, different `write` flag. `writeMem` sets `write: True` and passes
the data; `load` sets `write: False` and `datain: 0`.

---

### Hint 3 — the second half is a rule, not a method

This is the whole problem. `load` only issues the request. Something else has to pick
up the answer a cycle later:

```bsv
rule collect;
   let d <- bram.portA.response.get ();
   outQ.enq (d + 1);
endrule
```

Nobody calls this rule. It fires by itself whenever the BRAM has an answer and `outQ`
has room.

---

### Hint 4 — do not try to do it all in loadResult

A tempting wrong answer:

```bsv
method ActionValue #(Bit #(8)) loadResult ();     // WRONG
   let d <- bram.portA.response.get ();
   return d + 1;
endmethod
```

This compiles and even works when the testbench collects immediately. But it ties the
collection of a response to the consumer asking for it — so a consumer that pauses
leaves responses stuck in the BRAM, and you cannot have several loads in flight while
the consumer is elsewhere. The rule decouples them.

---

### Hint 5 — loadResult

Once `collect` is doing the work, this is just a FIFO drain:

```bsv
method ActionValue #(Bit #(8)) loadResult ();
   outQ.deq;
   return outQ.first;
endmethod
```
