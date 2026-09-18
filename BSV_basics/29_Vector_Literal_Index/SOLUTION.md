# Solution — 29

```bsv
method Vector #(4, Bit #(8)) build (Bit #(8) a, Bit #(8) b,
                                    Bit #(8) c, Bit #(8) d);
   return vec (a, b, c, d);
endmethod

method Bit #(8) elemAt (Vector #(4, Bit #(8)) v, Bit #(2) idx);
   return v[idx];
endmethod

method Bit #(8) lastElem (Vector #(4, Bit #(8)) v);
   return v[3];
endmethod
```

`elemAt` and `lastElem` look alike and are not: `v[3]` is a constant index, so it
is pure wiring, while `v[idx]` builds a 4-to-1 multiplexer eight bits wide. The
source does not distinguish them — the *nature of the index* does.

`idx` is a `Bit#(2)`, which is exactly wide enough for a 4-vector. That is not a
coincidence you have to maintain: pass a `Bit#(3)` and `bsc` objects, because the
length is in the type.
