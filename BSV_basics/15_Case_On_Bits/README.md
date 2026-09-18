# 15 — case

**Concept** the `case` *expression* and the `case` *statement*.

## The rule

BSV has two forms, and both are useful.

**As a statement**, with `return` in each arm:

```bsv
case (sel)
   2'b00: return a;
   2'b01: return b;
   2'b10: return c;
   2'b11: return d;
endcase
```

**As an expression**, producing a value you can name or return:

```bsv
Bit #(4) code = case (sel)
                   2'b00: 4'b0001;
                   2'b01: 4'b0010;
                   2'b10: 4'b0100;
                   2'b11: 4'b1000;
                endcase;
```

Note the trailing `;` on the expression form — it is part of a declaration.

A `Bit#(2)` has exactly four values, so listing all four makes the `case`
**complete** and no `default` is needed. (Problem 16 is about what happens when
it is not complete.)

## Your job

| method | must return |
|---|---|
| `mux4(sel,a,b,c,d)` | `a`/`b`/`c`/`d` for sel 0/1/2/3 |
| `oneHot(sel)` | `0001`, `0010`, `0100`, `1000` for sel 0/1/2/3 |

Use the statement form for one and the expression form for the other, so you
have written both.

## vs Verilog

A `case` in an `always @(*)` block with no `default` and a missing arm infers a
latch, silently. Here a complete `case` is complete and an incomplete one is a
compile-time complaint.

## Run it

```
Basics
```
