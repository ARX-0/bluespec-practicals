# 16 — default, and When You Need It

**Concept** an incomplete `case` needs a `default`; a complete one does not.

## The rule

A `case` must produce a value for **every** possible input. If your arms do not
cover the whole type, add `default`:

```bsv
return case (sel)
          3'd1: 8'hA1;
          3'd2: 8'hB2;
          default: 8'h00;       // the other six values
       endcase;
```

Leave it out when the arms are already exhaustive — that is not laziness, it is
a guarantee: if the input type later grows a value, the now-incomplete `case`
becomes a compile error instead of quietly falling into `default`.

So the rule is: **`default` when you genuinely mean "everything else", never as
a way to silence the compiler.**

## Case arms can also match a `case` on conditions

There is a second form, where each arm is a `Bool` and the first true one wins —
a priority encoder, without a subject expression:

```bsv
return case (True)
          (n[0] == 1): 0;
          (n[1] == 1): 1;
          default:     4;
       endcase;
```

## Your job

| method | must return |
|---|---|
| `lookup(sel)` | `8'hA1` for 1, `8'hB2` for 2, `8'hC4` for 4, `8'h00` otherwise |
| `firstSet(n)` | index of the lowest set bit of `n` (0–3), or `4` when `n` is zero |

## Run it

```
Basics
```
