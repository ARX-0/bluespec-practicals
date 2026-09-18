# Hints — 04

---

### Hint 1 — decode and encode are one line each

You are being asked to do the *opposite* of bit-slicing. The struct already
describes the layout. There is a function that converts raw bits into a value of
any type that derives `Bits`, and one that goes the other way.

Look again at the `deriving (Bits, ...)` clause and ask what it gave you.

---

### Hint 2 — the two functions

```bsv
unpack (raw)   // Bit#(n) -> your type
pack   (val)   // your type -> Bit#(n)
```

BSV works out which type from the method's declared return type. You do not name
`Instr` anywhere.

---

### Hint 3 — execute

A `case` over `op`. Four arms, one per opcode. Because you cover all four values of
the enum you can leave out `default` entirely.

---

### Hint 4 — near-code

```bsv
method Instr decode (Bit #(10) raw);
   return unpack (raw);
endmethod

method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
   case (op)
      OpAdd: return x + y;
      ...
   endcase
endmethod
```
