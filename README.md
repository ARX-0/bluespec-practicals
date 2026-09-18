# bluespec-practicals

Two HDLBits-style problem ladders for learning Bluespec SystemVerilog (BSV) by
writing it, not just reading about it. Each problem is a tiny, self-contained
`Top.bsv` with the interface given and the body left for you to fill in; a
checker compiles it and drives it with fixed stimulus, then tells you PASS or
the exact input/expected/got on the first mismatch.

- **[`BSV_basics/`](BSV_basics/)** — 42 problems, one idea each, one to three
  lines of answer. Start here. Covers the shape of a BSV file, types, control
  flow, enums/structs, `Maybe`, `Vector`, registers/rules, and FIFOs.
- **[`BSVbits/`](BSVbits/)** — 25 problems that build on the basics: rule
  conflicts, `CReg`, `RWire`/`DWire`, typeclasses, FSMs, `Get`/`Put`,
  client/server, pipelines, `RegFile`/BRAM. Written for someone who already
  knows Verilog — each README opens with the Verilog you'd have written, then
  shows the BSV.

Do `BSV_basics` first — `BSVbits` problem 04 asks for `typedef enum` +
`typedef struct` + `deriving` + `pack`/`unpack` + an exhaustive `case`, all at
once; `BSV_basics` breaks that same problem into seven separate steps
(18–24) before you meet it combined.

## Prerequisites

You need the Bluespec compiler (`bsc`) installed. Both ladders' runner scripts
look for it at `~/bsc/inst/bin`, `/opt/bsc/bin`, or `/usr/local/bsc/bin` — no
need to source Bluespec's own environment script, the scripts set
`BLUESPECDIR` themselves.

## Getting started

```bash
git clone https://github.com/ARX-0/bluespec-practicals.git ~/Documents/GitHub/bluespec-practicals
```

Add both ladders' runner scripts to your `PATH` — append this to `~/.bashrc`:

```bash
cat >> ~/.bashrc <<'EOF'
export PATH="$PATH:$HOME/Documents/GitHub/bluespec-practicals/BSV_basics"
export PATH="$PATH:$HOME/Documents/GitHub/bluespec-practicals/BSVbits"
EOF
source ~/.bashrc
```

(If you cloned somewhere other than `~/Documents/GitHub/bluespec-practicals`,
use that path instead.)

Check it's live:

```bash
cd ~/Documents/GitHub/bluespec-practicals/BSV_basics/01_Hello_Method
Basics 01
```

You should see a FAIL — that's the untouched stub, and it confirms the
checker runs before you've written anything. Same idea for the other ladder:

```bash
cd ~/Documents/GitHub/bluespec-practicals/BSVbits/01_Wire_And_Not
Run
```

## Day to day

```
Basics 07          # BSV_basics: check problem 07, from anywhere
Basics all         # check every problem, refresh PROGRESS.md
Basics --list      # ladder with current status
Basics -h           # help

Run 07             # BSVbits: check problem 07, from anywhere
Run --list          # ladder with current status
Run -h               # help
```

Edit only `Top.bsv` in a problem directory, and don't change the interface —
the checker calls your module through it, so a renamed method becomes a type
error instead of a result. Stuck for more than a couple minutes? Read
`SOLUTION.md` in that problem's directory — the explanation is the point.

Full details (directory layout, grading, troubleshooting, the full ladder
table) are in each ladder's own README: [`BSV_basics/README.md`](BSV_basics/README.md),
[`BSVbits/README.md`](BSVbits/README.md).
