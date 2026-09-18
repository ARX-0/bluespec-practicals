# 10 — CRegs: two rules, one register, one cycle

**Difficulty** ▮▮▮▮▯ · **Concepts** `mkCReg`, port ordering, concurrency vs conflict · **Prereq** 08

---

## The Verilog you'd write

```verilog
always @(posedge clk) begin
   if (phase == 3) begin
      total <= total + (cnt + 1);   // include this cycle's increment
      cnt   <= 0;
   end else
      cnt <= cnt + 1;
   phase <= phase + 1;
end
```

To make the drain see the increment, you wrote `cnt + 1` by hand. You serialised
the two behaviours yourself, in one block, and the `+ 1` is the seam.

## The problem

| method | behaviour |
|---|---|
| `current` | a counter, +1 every cycle, read as of the **start** of the cycle |
| `total` | every 4th cycle the counter — **including that cycle's increment** — is added to `total`, and the counter is zeroed |

Write it as **three rules**, and let a `CReg` do the serialising:

```
rule do_incr;                 // bump the counter, every cycle
rule do_drain (phase == 3);   // every 4th cycle, drain into total
rule do_phase;                // advance the phase, every cycle
```

## Tutorial: the BSV you need

In problem 08 two rules wanted one register and you picked a winner. Sometimes you
do not want a winner — you want **both, in a defined order, in the same cycle**.
A plain `mkReg` cannot express that: it has one write port, so two writers conflict
and at most one fires.

**A `CReg` ("concurrent register", also called an EHR) has numbered ports:**

```bsv
Reg #(Bit #(8)) cnt [2] <- mkCReg (2, 0);
```

That is one register with **two ports** — `cnt[0]` and `cnt[1]` — and the number
is the order within a cycle:

| | reads | writes |
|---|---|---|
| `cnt[0]` | the value at the **start** of the cycle | visible to `cnt[1]` **this** cycle |
| `cnt[1]` | what `cnt[0]` wrote (or start-of-cycle if it did not) | the value stored at the clock edge |

So a rule using port 0 is *logically before* a rule using port 1, within one clock
cycle. Both fire. Both see a consistent view. `mkCReg(2, 0)` means two ports,
reset value 0.

This is not two registers and it is not extra state — it is one flop plus the
bypass muxing that makes the ordering true.

**Port order constrains rule order.** Using `cnt[0]` in `do_incr` and `cnt[1]` in
`do_drain` *tells* `bsc` that `do_incr` is scheduled before `do_drain`. That is the
whole mechanism. Everything else in those rules must be consistent with that order,
which is why the phase counter needs its own rule — see below.

## What changed from Verilog

- **The `+ 1` fudge disappears.** `do_drain` reads `cnt[1]` and simply gets the
  post-increment value. The bypass is in the register, not smuggled into the
  arithmetic, so it cannot drift out of sync when `do_incr` changes.
- **The two behaviours stay separate.** In Verilog they had to share an `always`
  block to be ordered. Here they are independent rules with independent guards, and
  the ordering is a property of the register they share.
- **Ordering is now a scheduling fact the compiler checks.** If you ask for two
  contradictory orders, `bsc` says so at compile time (you may well see this — read
  the hints). Verilog would have let you write it and left you the waveform.
- **A CReg is not free.** Each extra port adds a bypass mux, and a long CReg chain
  becomes a long combinational path. Two ports is cheap and idiomatic; reaching for
  five is usually a sign the design wants restructuring.

## How you're checked

160 cycles, 40 drain events, comparing `current` and `total` every cycle. The
reference does the whole thing in one rule with plain registers and the manual
`cnt + 1` — correct, and exactly the pattern CRegs exist to replace.

## Run it

```
Run
```
