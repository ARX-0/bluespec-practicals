# Solution — 10

Only if dire.

---

```bsv
   Reg #(Bit #(8)) cnt [2] <- mkCReg (2, 0);
   Reg #(Bit #(8)) tot     <- mkReg (0);
   Reg #(Bit #(2)) phase   <- mkReg (0);

   rule do_incr;
      cnt[0] <= cnt[0] + 1;
   endrule

   rule do_drain (phase == 3);
      tot    <= tot + cnt[1];
      cnt[1] <= 0;
   endrule

   rule do_phase;
      phase <= phase + 1;
   endrule

   method Bit #(8) current = cnt[0];
   method Bit #(8) total   = tot;
```

## Why it is written this way

**The CReg does the serialising.** On a drain cycle both `do_incr` and `do_drain`
fire. `do_incr` writes `cnt[0]`; `do_drain` reads `cnt[1]` and therefore sees that
write, adds the post-increment value to `tot`, and writes `cnt[1] <= 0`, which is
the value that actually reaches the flop. One cycle, two rules, a defined order,
and no arithmetic fudge.

Compare `.check/Ref.bsv`, which gets the same result by writing `c + 1` inside a
single rule. That works, but the `+ 1` is a hand-maintained copy of what `do_incr`
does. Change the increment to `+ 2` and there are now two places to edit and one
of them is easy to miss. The CReg version has one increment, in one rule.

**Why `do_phase` is separate — the real lesson.** The natural first attempt puts
`phase <= phase + 1` inside `do_incr`. It fails, and `bsc` reports
`rule do_drain can never fire`. The reason is that two independent constraints
disagree:

- `cnt` (a CReg) says `do_incr` is **before** `do_drain` — port 0 precedes port 1.
- `phase` (a plain Reg) says `do_drain` is **before** `do_incr` — `do_drain` reads
  it and `do_incr` writes it, and a plain register's read sees the start-of-cycle
  value, so every reader is ordered ahead of the writer.

There is no schedule satisfying both, so `bsc` drops `do_drain`. Splitting the
phase update out gives the consistent order `do_incr → do_drain → do_phase`.

The general shape of this: **every shared piece of state imposes an ordering
constraint between the rules that touch it, and they all have to agree.** When
`bsc` says a rule can never fire, list what the rule reads and writes, list who
else touches those, and look for the cycle in the ordering.

**Why `current` is `cnt[0]`.** Port 0's read is the start-of-cycle value, which is
what the spec asks for. Reading `cnt[1]` would return the post-increment value and
would also add a constraint you do not want.

**Two ports, not more.** Each port is a bypass mux on the read path. Two is cheap
and extremely common. If you find yourself writing `mkCReg(4, ...)`, stop and ask
whether four rules really need to see each other's writes in one cycle, or whether
the design wants a FIFO instead.

## What to take forward

You now have three ways for rules to relate to one register, and they are the whole
vocabulary:

| you want | use | result |
|---|---|---|
| only one rule may write per cycle | `mkReg` + `descending_urgency` | they conflict; you pick a winner (problem 08) |
| both write, in a defined order, same cycle | `mkCReg` | both fire; port number is the order |
| pass a value between rules with no storage | `RWire` / `DWire` | problem 11 |

CRegs are the foundation of every high-throughput BSV structure — bypass FIFOs,
scoreboards, register files with forwarding, and the bypass network of a pipelined
CPU. When you later want an instruction to read a value that a later pipeline stage
is writing in the same cycle, this is the mechanism.
