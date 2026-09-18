# Solution — 12

Only if dire.

---

```bsv
   Reg #(Bit #(8)) total_r <- mkReg (0);
   Reg #(Bit #(8)) count_r <- mkReg (0);

   method Action add (Bit #(8) x);
      total_r <= total_r + x;
      count_r <= count_r + 1;
   endmethod

   method ActionValue #(Bit #(8)) takeAndClear ();
      total_r <= 0;
      return total_r;
   endmethod

   method Bit #(8) total () = total_r;
   method Bit #(8) count () = count_r;
```

## Why it is written this way

**`return total_r` after `total_r <= 0` is not a bug.** This is the one line worth
staring at. `<=` schedules a write for the clock edge; every read in the same cycle
still sees the old value. So the method returns the pre-clear total and leaves 0
behind — atomically, in one cycle, with no ordering to arrange.

Doing this in Verilog means either a combinational output sampled on the enable
cycle (and remembering not to read the register you just cleared) or a two-cycle
protocol. Here it is the default meaning of the code.

**`add` and `takeAndClear` conflict, and that is correct.** Both write `total_r`, so
`bsc` schedules them as mutually exclusive: no single rule may call both in one
cycle. The testbench calls them on separate cycles, so this never comes up — but it
is worth knowing that the conflict rules from problem 08 apply to *methods* exactly
as they do to rules. A caller trying to do both at once gets a compile error, not a
race.

**`._read` and `._write`.** `.check/Ref.bsv` writes `t._write (t._read + x)` where
you wrote `t <= t + x`. They are the same thing — `Reg#(t)` is an ordinary interface
with a value method `_read` and an `Action` method `_write`, and `<=` is sugar for
the latter. Nothing about registers is built into the language. That is why `mkCReg`
(problem 10) can offer the same interface with different semantics, and why you can
write your own register-like modules.

**Value methods with `=`.** `method Bit#(8) total () = total_r;` is the short form
for a method whose body is a single expression. Use it; the `return`/`endmethod`
form for a one-liner is noise.

## What to take forward

The three method kinds are the entire vocabulary for a module's interface, and the
choice is forced by what the method does:

- **needs to change state, returns nothing** → `Action`
- **needs to change state and hand something back** → `ActionValue#(t)`
- **just a function of current state** → a plain value method

Get this right and the generated Verilog handshake is right automatically. Problem
13 adds the missing piece: making a method *not ready*, so that callers block
instead of misbehaving.
