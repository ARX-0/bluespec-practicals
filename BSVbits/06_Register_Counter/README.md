# 06 — Registers and Rules

**Difficulty** ▮▮▯▯▯ · **Concepts** `mkReg`, `rule`, `<-` vs `=` vs `<=`, implicit reset · **Prereq** 05

---

> **This is the problem where BSV stops being Verilog with different syntax.**
> Everything up to here was combinational logic wearing a new coat. From here on
> the execution model is genuinely different. Read this whole README.

## The Verilog you'd write

```verilog
reg [7:0] count, delayed, evens;

always @(posedge clk) begin
   if (rst) begin
      count <= 0; delayed <= 0; evens <= 0;
   end else begin
      count   <= count + 1;
      delayed <= count;
      if (count[0] == 1'b0) evens <= evens + 1;
   end
end
```

You write the clock. You write the reset. You write the `if (rst)` arm, in every
`always` block, forever.

## The problem

| method | behaviour |
|---|---|
| `count` | increments by 1 every cycle from 0, wraps at 255 |
| `delayed` | the value `count` had one cycle ago (0 at the first cycle) |
| `evens` | increments by 1 only on cycles where `count` is even |

## Tutorial: the BSV you need

**A register is a module you instantiate**, not a variable you declare:

```bsv
Reg #(Bit #(8)) count <- mkReg (0);
```

`mkReg(0)` is a *module*; `<-` instantiates it. The `0` is the reset value, and
that is the entire reset story — no `rst` port to declare, no `if (rst)` arm to
write. `bsc` wires reset up for you and it is correct by construction.

**Three different arrows, and they are not interchangeable:**

| syntax | means | when |
|---|---|---|
| `<-` | instantiate a module / perform an ActionValue | `Reg#(..) r <- mkReg(0);` |
| `=`  | bind a name to a value (a wire, compile-time) | `Bit#(8) x = a + b;` |
| `<=` | **register write**, takes effect next cycle | `count <= count + 1;` |

`<=` is Verilog's non-blocking assignment and behaves the same way: reads see the
*old* value, the write lands at the clock edge. That is why

```bsv
count   <= count + 1;
delayed <= count;
```

does what you want — `delayed` gets the pre-increment `count`.

**A rule is a block of actions that fire together, atomically:**

```bsv
rule tick;
   count   <= count + 1;
   delayed <= count;
endrule
```

No `always @(posedge clk)`. No sensitivity list. There is one clock, it is
implicit, and every rule is synchronous to it.

**Reading a register is just its name.** `count` in an expression is the current
value; `count <= ...` is a write. No `.read`/`.write` needed (though `count._read`
exists if you ever need it explicitly).

**A value method can be a one-liner:**

```bsv
method Bit #(8) count = count_r;
```

Note the register and the method cannot share a name — hence the `_r` convention.

## What changed from Verilog

- **No clock, no reset, in the source.** Not hidden — *inferred*, and available
  when you need multiple clock domains. The single most common Verilog bug class
  (a missing or wrong reset arm) is gone.
- **Rules are atomic.** Everything in a rule body happens in the same cycle or none
  of it does. There is no partial execution. This becomes load-bearing in problem 08.
- **A rule with no condition fires every cycle it can.** These three rules are
  unconditional, so they fire every cycle — which is exactly the `always` block
  above. Problem 07 is about what a *condition* does, and it is not what you expect.
- **You can split logic into as many rules as you like**, and `bsc` schedules them.
  The solution here uses two rules where the Verilog used one `always` block; both
  are fine. Rules are not `always` blocks — they are smaller and more composable,
  and the compiler works out how they coexist.

## How you're checked

Both your module and the reference free-run from reset. The testbench watches both
for 200 cycles and compares all three outputs every cycle. The reference uses a
single combined rule and a different decomposition, so it agrees on behaviour
without hinting at structure.

## Run it

```
Run
```

After you pass, try `Run -v` and read `outputs/verilog/mkTop.v`. You will find the
`always @(posedge CLK)` block and the reset arm that `bsc` wrote for you.
