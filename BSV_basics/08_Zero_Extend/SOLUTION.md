# Solution — 08

```bsv
method Bit #(8) widen8 (Bit #(4) a);     return zeroExtend (a);  endmethod
method Bit #(16) widen16 (Bit #(8) a);   return zeroExtend (a);  endmethod

method Bit #(8) addNibble (Bit #(8) a, Bit #(4) n);
   return a + zeroExtend (n);
endmethod
```

The first two bodies are the same text producing different hardware (4→8 and
8→16), because the *return type* supplies the target width. This is the same
type-directed dispatch you saw with `unpack` in problem 07.

In `addNibble` the extension has to go on `n` — extending the wrong operand, or
forgetting it, is a width error naming the exact `+`.

There is also a general `extend`, which zero-extends unsigned types and
sign-extends signed ones. `zeroExtend` says what it does, so prefer it.
