# 24 — A pipeline around a memory latency

**Difficulty** ▮▮▮▮▯ · **Concepts** load-use, requests in flight, splitting a stage · **Prereq** 23

---

## The Verilog you'd write

```verilog
always @(posedge clk) begin
   mem_addr  <= load_addr;   mem_req <= load_valid;   // cycle 0: ask
   result    <= mem_dout + 1;                          // cycle 1: use
   result_valid <= mem_req;                            // and shift the valid
end
```

The load is spread across two cycles and you keep the pieces aligned by shifting a
`valid` bit alongside. Add a stall and you must stall both halves consistently, or the
response arrives for a request the pipeline has already forgotten.

## The problem

| method | behaviour |
|---|---|
| `writeMem(a,d)` | preload the memory |
| `load(a)` | issue a load of address `a`. Guarded |
| `loadResult()` | the next finished load, **in order**. The value is `mem[a] + 1`. Guarded |

The testbench issues a load **and** collects a result **in the same cycle**, 200 times
in a row. That only works if the two halves of a load are genuinely separate and
several can be in flight.

## Tutorial: the BSV you need

Nothing new — problems 19, 20 and 23 combined. The shape:

```bsv
BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);
FIFOF #(Bit #(8)) outQ <- mkSizedFIFOF (8);

// The FIRST half of a load: ask.
method Action load (Bit #(8) a);
   bram.portA.request.put (BRAMRequest { write: False, ..., address: a, ... });
endmethod

// The SECOND half: a RULE, firing a cycle later, whenever an answer shows up.
rule collect;
   let d <- bram.portA.response.get ();
   outQ.enq (d + 1);
endrule
```

**The rule is the point.** `collect` is not called by anybody and is not sequenced
with `load`. It fires whenever the BRAM has a response and `outQ` has room. The two
halves of a load are connected only by the BRAM's internal ordering — requests come
back in order — and by the FIFO.

**Several loads are in flight at once.** Issue on cycle 0, 1, 2; collect on 1, 2, 3.
Nothing tracks how many are outstanding, because nothing needs to: the BRAM holds the
pending request and `outQ` holds the finished ones.

**Why `mkSizedFIFOF(8)` and not `mkFIFOF`.** The output FIFO must be able to absorb
results while the consumer is busy. Depth 2 works here but leaves no slack; a deeper
queue decouples the two ends properly. In a real design the depth is set by how long
the consumer might stall.

## What changed from Verilog

- **No `valid` bit to shift.** Occupancy lives in the BRAM and the FIFO. There is no
  parallel shift register to keep aligned with the data.
- **Stalling is automatic and consistent.** If `outQ` fills, `collect` stops firing;
  the BRAM's response sits there; back-pressure reaches `load` when the BRAM's request
  queue fills. Nothing is dropped, and you wrote none of it.
- **The two halves cannot get out of step.** They are connected by the FIFO, not by
  two independently-maintained enables.
- **Adding latency is free.** Change the BRAM to a 3-cycle memory or a cache and
  `collect` does not change — it still fires when a response arrives.

## How you're checked

Preloads 256 locations, primes with two loads, then runs **200 cycles of simultaneous
load and collect**, then drains. Results must come back in order. The reference uses
registers with a combinational read and applies the `+1` at request time — no latency
to design around, so it defines the values and nothing about the structure.

A design that serialises load and collect will stall on the first simultaneous cycle
and trip the watchdog.

## Run it

```
Run
```
