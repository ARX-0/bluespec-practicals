# Hints — 23

---

### Hint 1 — the RegFile half

```bsv
RegFile #(Bit #(4), Bit #(8)) rf <- mkRegFileFull;
```

The two type parameters are index type and data type. Then the methods are direct:

```bsv
method Action rfWrite (Bit #(4) a, Bit #(8) d);
   rf.upd (a, d);
endmethod

method Bit #(8) rfRead (Bit #(4) a) = rf.sub (a);
```

`rf.sub` is a value method, so `rfRead` is a value method too. No request needed.

---

### Hint 2 — configuring the BRAM

```bsv
BRAM_Configure cfg = defaultValue;
cfg.memorySize = 256;
BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);
```

`defaultValue` comes from `DefaultValue` — it gives you a sensible config that you
then adjust.

---

### Hint 3 — a BRAM request

Both reads and writes go through the same request struct; `write` picks which:

```bsv
bram.portA.request.put (BRAMRequest {
   write:           True,       // or False for a read
   responseOnWrite: False,
   address:         a,
   datain:          d });       // ignored on a read
```

All four fields must be given.

---

### Hint 4 — the read response

It is an `ActionValue`, so bind it with `<-`:

```bsv
method ActionValue #(Bit #(8)) bramReadResp ();
   let d <- bram.portA.response.get ();
   return d;
endmethod
```

---

### Hint 5 — responseOnWrite

Keep it `False`. If it were `True`, every write would also queue a response, and your
read responses would come back interleaved with junk.
