# Solution — 34

```bsv
   Reg #(Bit #(8)) r <- mkReg (0);

   rule increment;
      r <= r + 1;
   endrule

   method Bit #(8) count ();
      return r;
   endmethod
```

The rule's name (`increment`) is not decoration — `bsc` uses it in scheduling
messages, and from problem 37 on those messages are the main thing you read when
a design misbehaves. Name rules for what they do.

`r <= r + 1` reads `r` and writes `r` in the same rule, and that is fine: the read
sees this cycle's value, the write lands next cycle. Every register write in BSV
works this way, so two rules cannot both write `r` in one cycle — `bsc` will
either schedule them in different cycles or refuse. That is problem 08 in the
BSVbits ladder.
