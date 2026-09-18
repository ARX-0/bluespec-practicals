# 12 — let, and Naming Intermediate Values

**Concept** naming a wire inside a method — with a type, or with `let`.

## The rule

Inside a method you can name intermediate values. Two forms:

```bsv
Bit #(9) wide = zeroExtend (a);   // you state the type
let      sum  = a + b;            // bsc infers it
```

Neither creates state. These are **wires with names** — the same `assign` you
would write in Verilog. There is no clock here and nothing is remembered between
calls.

Use `let` when the type is obvious from the right-hand side, and write the type
out when it matters — as it does whenever a width is being chosen deliberately.

## Example

```bsv
method Bit #(8) f (Bit #(8) a, Bit #(8) b);
   let      diff = a - b;
   Bit #(8) both = a & b;
   return diff | both;
endmethod
```

## Your job

| method | must return |
|---|---|
| `mix(a,b)` | `(a + b) ^ (a - b)` — name both halves first |
| `avg(a,b)` | `(a + b) / 2` computed **without losing the carry** |

For `avg`: eight-bit `a + b` overflows. Widen both to 9 bits (problem 08), add,
shift right by one, then narrow back to 8 (problem 10). `avg(200, 100)` is 150,
not 22.

## Run it

```
Basics
```
