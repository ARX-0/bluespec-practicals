# Solution — 14

Only if dire.

---

```bsv
module mkBank (Bank_IFC #(n, t))
   provisos (Bits #(t, sz));

   Vector #(n, Reg #(t)) rs <- replicateM (mkReg (unpack (0)));

   method Action upd (Bit #(TLog #(n)) idx, t v);
      rs[idx] <= v;
   endmethod

   method t sub (Bit #(TLog #(n)) idx);
      return rs[idx];
   endmethod

endmodule
```

and in `mkTop`:

```bsv
   Bank_IFC #(8, Bit #(8)) bytes <- mkBank;
   Bank_IFC #(4, Pair)     pairs <- mkBank;

   method Action updByte (Bit #(3) i, Bit #(8) v);
      bytes.upd (i, v);
   endmethod

   method Bit #(8) subByte (Bit #(3) i) = bytes.sub (i);

   method Action updPair (Bit #(2) i, Pair p);
      pairs.upd (i, p);
   endmethod

   method Pair subPair (Bit #(2) i) = pairs.sub (i);
```

## Why it is written this way

**`provisos (Bits #(t, sz))` is the minimum that makes it work.** The module needs
exactly one thing of `t`: that it can live in a register, which means it can be
packed into bits. It does not need `Eq`, does not need `FShow`, does not care what
`t` means. Ask for the least you need — a module with unnecessary provisos cannot
be instantiated at types that would otherwise be fine.

**`sz` is never used in the body.** It exists so the proviso can name the width.
This looks odd the first time; it is completely normal BSV.

**`unpack (0)` rather than a specific reset value.** You cannot write a literal of
an unknown type. `unpack(0)` means "the value whose bit pattern is all zeros",
which is well-defined for any `t` with a `Bits` instance. For `Bit#(8)` it is `0`;
for `Pair` it is `Pair { a: 0, b: False }`.

**No `(* synthesize *)` on `mkBank`.** A `synthesize` attribute asks `bsc` to emit
one separately-compiled Verilog module, and a polymorphic module is not one piece of
hardware — it is a template. The two instantiations in `mkTop` elaborate into two
different circuits. `mkTop` itself is concrete and keeps its `synthesize`.

**`Bit#(TLog#(n))` computes and enforces the index width.** The 8-entry bank takes
`Bit#(3)`, the 4-entry bank takes `Bit#(2)`, and `mkTop`'s method signatures happen
to match. If they did not, it would be a compile error at the point of the mismatch
rather than an address bit quietly going nowhere.

**Compare `.check/Ref.bsv`**: two hand-written banks, each with its own `Vector`, its
own methods, its own literal reset value. It is not much longer *for two banks*. It
is twice as much code to keep correct, and a third element type means a third copy.

## What to take forward

Polymorphism plus provisos is how every piece of the BSV standard library is
written, and reading them is now within reach:

```bsv
module mkFIFO (FIFO #(element_type))
   provisos (Bits #(element_type, width_any));
```

That is `mkFIFO`'s actual signature, and it says exactly what yours does: any
element type, as long as it can be stored as bits.

The habit to build: when you write a module twice at different widths or types,
stop and make it one polymorphic module. In Verilog that instinct is often wrong
because parameterisation gets painful. In BSV it is almost always right.
