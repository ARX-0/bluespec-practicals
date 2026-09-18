# 06 — UInt and Int

**Concept** three types over the same bits: `Bit#(n)`, `UInt#(n)`, `Int#(n)`.

## The rule

All three are `n` wires. They differ in what the operators *mean*:

| type | `+ - < >` mean | `& | ^ ~` |
|---|---|---|
| `Bit#(n)` | unsigned arithmetic | yes — this is the bit-vector type |
| `UInt#(n)` | unsigned arithmetic | no |
| `Int#(n)` | **two's-complement signed** arithmetic | no |

So the *type* carries the signedness. There is no `$signed()` cast at the point
of use and no rule about "if any operand is unsigned the whole expression is" —
you choose the type once, when you declare the value.

`8'hC8` read as `UInt#(8)` is 200. The same bits read as `Int#(8)` are −56.

## Example

```bsv
UInt #(8) big   = 200;
Int  #(8) small = -56;      // the same eight bits
Bool  b1 = (big  > 100);    // True
Bool  b2 = (small > 100);   // False
```

## Your job

| method | must return |
|---|---|
| `sumU(a,b)` | `a + b` |
| `lessU(a,b)` | `a < b`, unsigned |
| `lessS(a,b)` | `a < b`, signed |

The bodies are identical. The *types in the interface* are what make the last
two different circuits.

## vs Verilog

`reg signed [7:0]` versus `reg [7:0]`, except that mixing them is a type error
instead of a silent promotion to unsigned.

## Run it

```
Basics
```
