# 35 — Reset Values

**Concept** the reset value is an argument to `mkReg`, and it can be any type.

## The rule

`mkReg`'s argument is the value the register holds after reset:

```bsv
Reg #(Bit #(8)) a    <- mkReg (7);
Reg #(Bool)     busy <- mkReg (False);
Reg #(Opcode)   op   <- mkReg (OpAdd);        // an enum, from problem 18
Reg #(Point)    p    <- mkReg (Point { x: 0, y: 0 });
```

**A register can hold any type that derives `Bits`** — that is what `Bits` was
for. A struct in a register is one register, as wide as the struct.

Each register gets its own reset value, written where the register is created.
There is no central reset block that has to list them all and be kept in step,
and no register that someone forgot to add to it.

## Your job

Instantiate three registers with the reset values in the comments, and return
each from its method.

| method | must return |
|---|---|
| `a()` | 7 |
| `b()` | 200 |
| `flag()` | `True` |

Nothing writes them, so each stays at its reset value.

## vs Verilog

```verilog
always @(posedge clk or negedge rst_n)
   if (!rst_n) begin
      a <= 8'd7;
      b <= 8'd200;
      flag <= 1'b1;
   end
```

One block listing every register, repeated in every module, and the classic bug
is a register that never made it into the list. Here the value lives with the
register.

## Run it

```
Basics
```
