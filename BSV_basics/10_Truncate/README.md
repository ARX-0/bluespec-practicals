# 10 — truncate

**Concept** narrowing, and which end gets thrown away.

## The rule

```
truncate    (x)   // keeps the LOW bits,  drops the high ones
truncateLSB (x)   // keeps the HIGH bits, drops the low ones
```

Like the extend functions, the result width comes from context, and `bsc` errors
if you ask for a *wider* result than the input.

Narrowing always throws bits away — that is what it is for. BSV makes you say so
in one word, so a lost high bit is a decision in the source rather than a
warning you scrolled past.

## Example

```bsv
Bit #(16) w = 16'hABCD;
Bit #(8)  a = truncate    (w);   // 8'hCD
Bit #(8)  b = truncateLSB (w);   // 8'hAB
```

(Yes, the name is odd. `truncateLSB` means "truncate *at* the LSB end", i.e.
the low bits are the ones removed.)

## Your job

| method | must return |
|---|---|
| `low4(a)` | bits 3:0 of `a` |
| `low8(a)` | bits 7:0 of `a` |
| `high4(a)` | bits 7:4 of `a` |

## Run it

```
Basics
```
