# Solution — 33

```bsv
   Reg #(Bit #(8)) r <- mkReg (42);

   method Bit #(8) get ();
      return r;
   endmethod
```

`return r` reads the register's current value. There is no `.read` to call —
a `Reg` used where a value is expected *is* its contents. (The long form,
`r._read`, exists and is what `r` expands to; you will never type it.)

Nothing writes `r`, so it holds 42 forever. `bsc` may point out that the register
is never assigned; that is expected here.

The register still costs eight flip-flops even though nothing changes them —
`(* synthesize *)` keeps the module intact. A synthesis tool would later optimise
them away.
