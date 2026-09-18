# 32 — fold

**Concept** combining a whole vector down to one value.

## The rule

Where `map` gives you n results, `fold` gives you one:

```bsv
fold (f, v)      // f applied pairwise across the vector
```

`fold` builds a **balanced tree**, so a 4-element sum is two adders then one —
depth 2, not 3. That is the shape you want for timing, and you get it without
drawing it.

To pass an operator as a function, write it with a backslash:

```bsv
fold (\+ , v)      // sum      -- note the space after +
fold (\| , v)      // bitwise OR of every element
```

`max` and `min` are ordinary Prelude functions, so `fold (max, v)` works too.

There is also `foldr (f, seed, v)`, which takes a starting value and is the right
choice when the vector might be empty or when the accumulator has a different
type from the elements.

## Example

```bsv
method Bit #(8) sumOf (Vector #(4, Bit #(8)) v);
   return fold (\+ , v);
endmethod
```

## Your job

| method | must return |
|---|---|
| `total(v)` | the sum of all elements |
| `biggest(v)` | the largest element |
| `allNonZero(v)` | `True` when no element is `0` |

For `allNonZero`, `map` first (problem 31) — with a small package-level function,
since BSV has no anonymous functions — then fold the resulting `Bool`s with
`\&& `. This map-then-fold pairing is what the two problems were building toward.

## Run it

```
Basics
```
