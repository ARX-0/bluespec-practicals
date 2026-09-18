# 20 — Client, Server, and a multi-cycle unit

**Difficulty** ▮▮▮▮▯ · **Concepts** `Server`/`Client`, request/response, multi-cycle units, `toGet` · **Prereq** 19

---

## The Verilog you'd write

```verilog
input  wire        req_valid;   input wire [7:0] req_a, req_b;
output wire        req_ready;
output reg         resp_valid;  output reg [15:0] resp_data;
input  wire        resp_ready;
```

Six signals, two handshakes, and a state machine that must not accept a new request
while busy — enforced by remembering to clear `req_ready`, in the right cycle, in
every state.

## The problem

A **shift-and-add multiplier** taking 8 cycles per result, behind the standard
request/response interface:

```bsv
typedef struct { Bit #(8) a; Bit #(8) b; } MulReq deriving (Bits, Eq, FShow);

interface Mul_IFC;
   interface Server #(MulReq, Bit #(16)) srv;
endinterface
```

`8'hFF × 8'hFF` must give `16'hFE01` (65025), so nothing may overflow.

You may not use `*`. The point is the multi-cycle protocol around the arithmetic.

## Tutorial: the BSV you need

**`Server` and `Client` are just a `Get` and a `Put` paired up:**

```bsv
interface Server #(req, resp);      interface Client #(req, resp);
   interface Put #(req)  request;      interface Get #(req)  request;
   interface Get #(resp) response;     interface Put #(resp) response;
endinterface                        endinterface
```

A `Server` accepts requests and produces responses; a `Client` is the mirror image.
`mkConnection (someClient, someServer)` wires all four methods in one line.

This is the shape of every memory port, every bus slave, every long-latency
functional unit — and of AXI, which is several `Client`/`Server` pairs (one per
channel) with a struct on each.

**Shift and add**, the algorithm:

```
prod = 0
repeat 8 times:
   if (mplr[0] == 1) prod = prod + mcand
   mcand = mcand << 1
   mplr  = mplr >> 1
```

Keep `mcand` and `prod` at 16 bits so the shifting has room.

**The multi-cycle protocol** is a state register plus guards:

```bsv
Reg #(Bit #(4)) step <- mkReg (8);       // 8 == idle, 0..7 == working

rule iterate (step < 8);
   ...
endrule

method Action put (MulReq r) if (step == 8);   // only when idle
   ...
endmethod
```

`step == 8` as the idle marker means `put`'s guard and `iterate`'s guard are
mutually exclusive, so `bsc` proves the two never conflict even though both write
`step`.

**Hand the result over through a FIFO**, not straight out of `prod`:

```bsv
FIFOF #(Bit #(16)) outQ <- mkFIFOF;
...
interface response = toGet (outQ);
```

That way `response.get` is guarded on there actually being a result. Returning
`prod` directly would let a caller read a stale value before the first request.

## What changed from Verilog

- **"Busy" is a guard, not a signal you remember to clear.** `put` is not ready
  while `step < 8`. There is no state in which the module can accept a request it
  cannot serve, because the readiness *is* the state.
- **The two handshakes are generated.** `RDY_put`/`EN_put` and
  `RDY_get`/`EN_get` come out of the guards. You write neither.
- **Latency is invisible to the caller.** A caller does `put` then `get` and blocks
  as needed. Change this to a 1-cycle or 32-cycle unit and no caller changes. That
  is the property that makes memory hierarchies composable.
- **`mkConnection` works on it.** Because it is a standard `Server`, any `Client` can
  drive it with one line.

## How you're checked

80 multiplications, one at a time, with `255 × 255` forced on round 0. Compared
against a reference that just uses `*` — the arithmetic is not the interesting part,
the protocol is. A unit that never responds trips the watchdog; one that accepts a
request while busy corrupts its own state and fails on a value.

## Run it

```
Run
```
