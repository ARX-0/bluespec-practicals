# Solution — 25

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

## Why it is this short

`Instr` contains an `Opcode`, and `Opcode` derives `Bits`, so `Instr` derives
`Bits` too — the nesting works out on its own. `unpack` therefore knows to take
bits [9:8], turn them into an `Opcode`, and put the other eight in `rd` and `rs`.

`decode` and `encode` are inverses because they are generated from **one**
declaration. In the Verilog version they are two hand-written pieces of code that
merely *agree* today.

No `default` in the `case`: all four opcodes are covered, so adding `OpXor` later
makes this exact `case` a compile error instead of silently routing XOR to OR.

## What to take forward

Every structured value in a BSV design is this pattern — instructions, bus
transactions, packet headers, cache tags. Declare the struct with
`deriving (Bits, Eq, FShow)`, `pack` it onto wires, `unpack` it off. When you get
to AXI, the address, write and response channels are exactly this and nothing
more.
