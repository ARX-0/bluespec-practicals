# 30 — replicate and update

**Concept** building a whole vector at once, and replacing one element.

## The rule

```bsv
replicate (x)          // every element is x
update (v, i, x)       // a COPY of v with element i replaced by x
```

`replicate` takes the length from context, like `zeroExtend` takes its width.

`update` **returns a new vector**; it does not modify `v`. A `Vector` is a value,
just like a struct (problem 22) — there is nothing to modify. With a run-time
`i`, `update` builds a decoder plus a mux in front of each element, which is
precisely the write port you would draw by hand.

## Example

```bsv
Vector #(3, Bit #(4)) zeros = replicate (0);
Vector #(3, Bit #(4)) one   = update (zeros, 1, 4'hF);   // [0, F, 0]
```

## Your job

| method | must return |
|---|---|
| `allSame(x)` | `[x, x, x, x]` |
| `setOne(v,idx,x)` | `v` with element `idx` set to `x` |
| `onlyFirst(x)` | `[x, 0, 0, 0]` |

`onlyFirst` is `replicate` and `update` composed — no new idea.

## Run it

```
Basics
```
