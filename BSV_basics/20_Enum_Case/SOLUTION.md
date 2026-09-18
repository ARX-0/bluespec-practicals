# Solution — 20

```bsv
method Bit #(8) execute (Opcode op, Bit #(8) x, Bit #(8) y);
   case (op)
      OpAdd: return x + y;
      OpSub: return x - y;
      OpAnd: return x & y;
      OpOr:  return x | y;
   endcase
endmethod
```

No `default`, on purpose — see the README. This is a four-input multiplexer in
front of an adder, a subtractor and two gate rows: exactly the ALU you would
draw.

If `bsc` complains that the `case` is incomplete, you have missed an arm or
misspelled a value; the message names the type, so the four legal spellings are
in the error itself.
