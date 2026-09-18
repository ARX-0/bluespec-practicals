# Solution — 11

Only if dire.

---

```bsv
   Reg #(Bit #(8))   tick_r <- mkReg (0);
   Reg #(Bit #(8))   hits_r <- mkReg (0);
   Reg #(Bit #(8))   last_r <- mkReg (0);
   RWire #(Bit #(8)) pulse  <- mkRWire;

   rule produce (tick_r[1:0] == 0);
      pulse.wset (tick_r);
   endrule

   rule consume (isValid (pulse.wget));
      hits_r <= hits_r + 1;
      last_r <= fromMaybe (0, pulse.wget);
   endrule

   rule advance;
      tick_r <= tick_r + 1;
   endrule

   method Bit #(8) tick = tick_r;
   method Bit #(8) hits = hits_r;
   method Bit #(8) last = last_r;
```

## Why it is written this way

**The wire carries the value with no cycle of latency.** `produce` and `consume`
both fire on a pulse cycle, in that order, and `last_r` and `hits_r` are written
together. Replace the `RWire` with a `Reg` and `last` lags by one cycle — the
checker catches it on the very first pulse.

**`mkRWire`, not `mkDWire(0)`.** The first pulse occurs at `tick == 0`. A `DWire`
with default `0` reads as `0` on every non-pulse cycle too, so "a pulse carrying the
value 0" and "no pulse" become the same observation. `Maybe` keeps them apart.

The rule of thumb: **use `mkDWire` when the default is a genuine value the consumer
can act on, and `mkRWire` when absence has to be distinguishable from any possible
payload.** For a counter's value, a valid bit, or anything where zero is meaningful,
that means `mkRWire`.

**Guarding on `isValid` rather than pattern-matching inside.** Both work. The guard
is better because it states the truth — this rule has nothing to do when the wire is
empty — and a guard is visible to the scheduler, which an `if` inside the body is
not (problem 07). Here it makes no practical difference; in a design where `consume`
also touched something contested, it would.

**Three rules, and `advance` on its own.** `produce` reads `tick_r`, so it must be
scheduled before whoever writes it. Keeping the write in its own rule gives a clean
consistent order — `produce → consume → advance` — with nothing to resolve. Folding
`tick_r <= tick_r + 1` into `produce` would also work here, but only because
`produce` reads and writes it in the same rule; the separate rule is the habit that
keeps scaling.

## What to take forward

`Maybe#(t)` is everywhere in BSV: `wget`, `RegFile` lookups, cache hits, decoded
instructions that might be illegal, FIFO peeks. The vocabulary is small:

```bsv
tagged Valid v / tagged Invalid   -- the two constructors
isValid (m)                       -- Bool
fromMaybe (dflt, m)               -- payload, or dflt
case (m) matches ...              -- pattern match, handles both
```

And the three rule-to-rule mechanisms are now complete:

| need | mechanism | latency |
|---|---|---|
| value next cycle | `mkReg` | 1 cycle |
| value this cycle, ordered writes | `mkCReg` | 0, stateful |
| value this cycle, no storage | `mkRWire` / `mkDWire` | 0, stateless |

That is the end of Chapter 2. You have the whole BSV execution model now — atomic
guarded rules, a scheduler that orders them from what they touch, and three ways to
share state. Everything after this is built out of these pieces.
