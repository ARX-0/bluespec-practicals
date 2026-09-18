# Solution — 02

Only if dire.

---

```bsv
method Bit #(8) mux4 (Bit #(2) sel,
                      Bit #(8) d0, Bit #(8) d1, Bit #(8) d2, Bit #(8) d3);
   return case (sel)
             0: d0;
             1: d1;
             2: d2;
             default: d3;
          endcase;
endmethod

method Bit #(8) swapNibbles (Bit #(8) x);
   return { x[3:0], x[7:4] };
endmethod

method Bool ugt (Bit #(8) a, Bit #(8) b);
   return a > b;
endmethod

method Bool sgt (Bit #(8) a, Bit #(8) b);
   Int #(8) ia = unpack (a);
   Int #(8) ib = unpack (b);
   return ia > ib;
endmethod
```

## Why it is written this way

**`ugt` needs no conversion.** `Bit#(n)` compares unsigned already. Writing
`UInt#(8) ua = unpack(a);` first is harmless and arguably clearer about intent,
but it generates identical hardware. The reference does it that way; the direct
form is the one you will actually write.

**`sgt` needs the conversion, and that is the point.** There is no `$signed()` in
BSV because there is nowhere to put it: `>` is chosen by the operand type. To get
signed comparison you must *have* signed operands. This forces the signedness
decision up to where the value is created rather than leaving it at every
comparison site — which is precisely the class of Verilog bug (an accidental
unsigned compare on a value that was meant to be signed) that BSV is designed to
make unrepresentable.

**`unpack` costs nothing.** `Bit#(8)`, `UInt#(8)` and `Int#(8)` are all eight
wires. `pack`/`unpack` are pure retyping; they emit no gates. Use them freely.

## What to take forward

`pack` / `unpack` are how *everything* moves between "structured value" and "raw
bits" in BSV — enums, structs, vectors, all of it. Problem 04 uses them on a
struct, and you will keep using them until the end.
