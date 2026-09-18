# Solution — 04

Only if dire.

---

```bsv
method Instr decode (Bit #(10) raw);
   return unpack (raw);
endmethod

method Bit #(10) encode (Instr i);
   return pack (i);
endmethod

method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
   case (op)
      OpAdd: return x + y;
      OpSub: return x - y;
      OpAnd: return x & y;
      OpOr:  return x | y;
   endcase
endmethod
```

## Why it is written this way

**`decode` and `encode` are one line because the type already contains the
information.** The reference in `.check/Ref.bsv` writes out `raw[9:8]`, `raw[7:4]`,
`raw[3:0]` and a four-arm `case` mapping the opcode bits by hand. It is correct, and
it is what you would have to write in Verilog — about twenty lines that must be kept
consistent with a comment. `unpack` is the same hardware with the layout stated once.

Compare them side by side. That contrast *is* problem 04.

**No `default` in the `case`.** `Opcode` has four values and all four are listed, so
the `case` is total and `bsc` is satisfied. This is better than a `default` arm: if
someone later adds `OpXor` to the enum, a `default` would silently route it to OR,
whereas the exhaustive form becomes a compile error pointing at exactly the code
that needs updating. Prefer exhaustive `case` over `default` on enums, always.

**Field order matters and is fixed by the `typedef`.** `op` is declared first so it
occupies the high bits. If you had wanted `rs` in the high bits you would reorder the
`typedef`, not change `pack`.

## What to take forward

This is the pattern for every structured value in a BSV design — instructions, bus
transactions, packet headers, cache tags. Declare a struct with `deriving (Bits, Eq,
FShow)`, then `pack` it onto wires and `unpack` it off them. When you get to AXI
later, the address/write/response channels are exactly this and nothing more.

`FShow` in particular is worth the habit: a design whose types all derive `FShow`
gives you readable simulation output for free, forever.
