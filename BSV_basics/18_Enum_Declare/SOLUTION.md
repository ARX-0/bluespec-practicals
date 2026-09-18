# Solution — 18

At package level, above the interface:

```bsv
typedef enum { Red, Green, Blue }
   Color deriving (Bits, Eq, FShow);
```

Module body:

```bsv
   method Bit #(2) redBits ();    return pack (Red);    endmethod
   method Bit #(2) greenBits ();  return pack (Green);  endmethod
   method Bit #(2) blueBits ();   return pack (Blue);   endmethod
```

Three values need two bits, and `bsc` picked `Bit#(2)` on its own — that is why
the methods return `Bit#(2)` and not `Bit#(3)` or `Bit#(8)`.

You will almost never write `pack` on an enum in real code; it is here so the
checker can look at the encoding. Normally you pass `Red` around as a `Color` and
never think about its bits at all — which is the entire benefit.
