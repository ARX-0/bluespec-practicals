# 23 — RegFile and BRAM: two kinds of memory

**Difficulty** ▮▮▮▯▯ · **Concepts** `mkRegFileFull`, `mkBRAM1Server`, read latency, uninitialised memory · **Prereq** 22

---

## The Verilog you'd write

```verilog
reg [7:0] mem [0:255];
always @(posedge clk) begin
   if (we) mem[wa] <= wd;
   rd <= mem[ra];        // registered read -> infers BRAM
end
assign rd_comb = mem[ra];  // combinational read -> infers flops or LUTRAM
```

Whether you get block RAM or a pile of flip-flops depends on whether you happened to
register the read, and on your synthesis tool's inference rules. Same array
declaration, wildly different hardware, decided implicitly.

## The problem

Use **both** kinds, and notice the difference is *read latency*:

| method | behaviour |
|---|---|
| `rfWrite(a,d)` / `rfRead(a)` | 16-entry RegFile. Read is **combinational** — same cycle, no request |
| `rfBramWrite(a,d)` | 256-entry BRAM write |
| `bramReadReq(a)` then `bramReadResp()` | BRAM read, split across **two** cycles |

## Tutorial: the BSV you need

**`RegFile` — combinational read:**

```bsv
import RegFile :: *;

RegFile #(Bit #(4), Bit #(8)) rf <- mkRegFileFull;

rf.upd (a, d);      // Action: write
rf.sub (a)          // value method: read, THIS cycle
```

`mkRegFileFull` covers the whole address space implied by the index type. It
synthesises to flip-flops with a read mux — cheap at 16 entries, ruinous at 16384.

**`BRAM` — one cycle of read latency, so it is a `Server`:**

```bsv
import BRAM         :: *;
import DefaultValue :: *;

BRAM_Configure cfg = defaultValue;
cfg.memorySize = 256;
BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);

bram.portA.request.put (BRAMRequest {
   write:           False,      // True to write
   responseOnWrite: False,
   address:         a,
   datain:          0 });

let d <- bram.portA.response.get ();     // next cycle
```

`bram.portA` is a `Server#(BRAMRequest#(a,d), d)` — the *same* `Put`/`Get` pair as
problem 20. A memory with latency and a multi-cycle multiplier have the same shape,
because the shape follows from the latency, not from what the unit does.

**Both memories come up uninitialised.** `mkRegFileFull` and `mkBRAM1Server` have no
reset value — reading an address you never wrote gives an arbitrary value. This is
not a BSV quirk; it is what the hardware does, and it is why the testbench writes
every location before reading any of them.

## What changed from Verilog

- **The choice is explicit.** You instantiate `mkRegFileFull` or `mkBRAM1Server`. There
  is no inference to second-guess and no surprise when a tool decides differently.
- **Latency is in the interface, so it cannot be forgotten.** A BRAM read is a request
  and a response. There is no way to write code that expects the data this cycle,
  because the method that returns it does not exist yet.
- **Backpressure comes along for free.** The response `Get` is guarded, so a consumer
  that is not ready simply does not collect, and nothing is lost.
- **Uninitialised is visible.** In Verilog an unwritten `mem[i]` reads as `x` in
  simulation and as something else in silicon. BSV has no `x`; you get a definite but
  arbitrary value, which is more honest and still a bug if you rely on it.

## How you're checked

The testbench **preloads all 256 BRAM and all 16 RegFile locations** — necessary,
since neither memory has a reset value — then runs 150 randomised rounds, including a
read of an address it did *not* just write, to catch a memory that returns the last
value written regardless of address.

## Run it

```
Run
```
