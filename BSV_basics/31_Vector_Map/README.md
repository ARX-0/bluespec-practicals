# 31 — map

**Concept** applying one function to every element — a row of identical logic.

## The rule

```bsv
map (f, v)
```

builds a new vector by applying `f` to each element. For a 4-vector that is
**four separate copies of f's hardware**, all working at once. There is no loop
and no sequencing — `map` is a way of writing "one of these per element" without
copying and pasting.

`f` can change the element type. `map` over a `Vector#(4, Bit#(8))` with a
function returning `Bool` gives a `Vector#(4, Bool)`.

Any function will do — one you wrote (problem 17) or a library one. BSV has no
anonymous-function syntax, so if you need a one-off, give it a name at package
level. That is not a limitation worth fighting: the name usually says what the
row of hardware is for.

## Example

```bsv
function Bit #(8) addOne (Bit #(8) x) = x + 1;

method Vector #(4, Bit #(8)) bumpAll (Vector #(4, Bit #(8)) v);
   return map (addOne, v);
endmethod
```

Note `addOne` with no arguments — you are passing the *function*, not calling it.

## Your job

| method | must return |
|---|---|
| `doubleAll(v)` | every element times 2, wrapping at 8 bits |
| `nonZero(v)` | `True` in each position where the element is not `0` |

Write two small package-level functions, one for each `map`.

## vs Verilog

```verilog
genvar g;
generate for (g = 0; g < 4; g = g + 1) begin
   assign out[g] = in[g] * 2;
end endgenerate
```

Five lines of scaffolding around one line of logic, and the loop bound repeated
separately from the array size. `map` is the same generated hardware with the
count coming from the vector's own type.

## Run it

```
Basics
```
