# Solution — 24

```bsv
method Header fromBits (Bit #(16) raw);
   return unpack (raw);
endmethod

method Bit #(4) tagOf (Bit #(16) raw);
   Header h = unpack (raw);
   return h.tag;
endmethod
```

`fromBits` is one line because the method's return type already says `Header`,
so `unpack` has everything it needs.

`tagOf` needs the intermediate: `return unpack (raw).tag;` has nothing to tell
`unpack` which type to produce — the field name `tag` is not enough, since many
structs could have one. Declaring `Header h` supplies it. When you meet a
"not enough explicit type information" error from `bsc`, this is almost always
the shape of the fix: name the type of an intermediate.
