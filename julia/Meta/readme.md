# MetaProgramming with Julia&mdash; some helpful results I have found

## Findings

### Getting current function information

You can get a function name by obtaining the top level stacktrace.  The `stacktrace()` function will return a list of stacktrace frames, which is a type `Vector{Base.StackTraces.StackFrame}`.  `Base.StackTraces.StackFrame` has the properties `func, file, line, linfo, from_c, inlined, pointer`.  Importantly, the `func` property gives us the name of the function as a `Symbol`:
```julia
julia> foo() = Base.StackTraces.stacktrace()[1].func
foo (generic function with 1 method)

julia> foo()
:foo
```

NOTE: you can access the function's method this way.  This is important to note, as I was previously iterating over the methods table for the function name to see if I can find the correct method for the current function.  This iteration is not needed, if all you need is the current function:
```julia
julia> foo() = Base.StackTraces.stacktrace()[1].linfo.def
foo (generic function with 1 method)

julia> foo()
foo() in Main at REPL[1]:1
```

### Methods

Getting the methods of a function is well-known.  However, I only ever interactively read the results of `methods`.  Never had I actually parsed its results.  `methods` actually returns a type `Base.MethodList`, which has the fields `ms` (a list of methods, of type `Vector{Method}`), and `mt` (a `Core.MethodTable`).  It should be noted that the `Base.MethodList` is iterable.

#### `ms`

The `Method` struct has the fields `name, module, file, line, primary_world, deleted_world, sig, specializations, speckeyset, slot_syms, source, unspecialized, generator, roots, ccallable, invokes, nargs, called, nospecialize, nkw, isva, pure`.  Important to us is the `sig` field, which is a `Type{Tuple}`.  For example, if we had the function `foo(a::Int, b::String)`, the `sig` field for this method would return `Tuple{typeof(foo), Int, String}`.  You can get the number of arguments of this, either by computing the length of the signature minus the function name (one), or using the `nargs` field:
```julia
julia> m = methods(foo).ms[1]
foo(a::Int64, b::String) in Main at REPL[1]:1

julia> m.nargs - 1
2

julia> Base._counttuple(m.sig) - 1
2

julia> length(m.sig.parameters) - 1
2
```

The last one works because the `Tuple` `Type` has a field `parameters` which returns a vector of `Type`s for the types given:
```julia
julia> Tuple{Int, UInt8, SubString}.parameters
svec(Int64, UInt8, SubString)
```

This vector is of the type `Core.SimpleVector`.

#### `mt`

The `Core.MethodTable` struct has the fields `name, defs, leafcache, cache, max_args, kwsorter, module, backedges, offs`.  Each element of `mt.defs` is a `Core.TypeMapEntry`, whose fields are `next, sig, simplesig, guardsigs, min_world, max_world, func, isleafsig, issimplesig, va`.  However, the field `next` only exists if there is another method to follow.

#### Iteration of methods

`Base.MethodList` is iterable, so you can simply write
```julia
for m in methods(foo)
	# ...
end
```

Before I realised it was iterable, I used something a little less elegant:
```julia
atlast = false
m = methods(foo).mt.defs.func
while true
    hasnext = isdefined(m, :next) # can use has
    if !hasnext
    atlast = true
    end
    if !hasnext && atlast
        break
    end
    m = m.next.func
	# ... 
end
```

### Code Information

One of the defining things about a Turing complete system (so I believe?) is that is should have the ability to introspect&mdash;; to read its own code.  Once you have located a method, you can give your `Method` to the function `uncompressed_ir` to obtain code information:

```julia
julia> foo() = nothing
foo (generic function with 2 methods)

julia> Base.uncompressed_ir(methods(foo).ms[1])
CodeInfo(
    @ REPL[1]:1 within `foo'
1 ─     return Main.nothing
)

julia> foo(a::Int, b::Int) = a + b
foo (generic function with 2 methods)

julia> Base.uncompressed_ir(methods(foo).ms[2])
CodeInfo(
    @ REPL[3]:1 within `foo'
1 ─ %1 = a + b
└──      return %1
)
```

It should be noted that `uncompressed_ir` was previously called `uncompressed_ast` (which still works for backward compatability), as AST is the abstract syntax tree.  IR in this context likely stands for instruction register.



### Checking Properties and Fields

```julia
julia> struct Foo
       bar::Any
       end

julia> isdefined(Foo, :bar) # isdefined checks if object Foo() has property `bar`, not Type{Foo}
false

julia> isdefined(Foo(1), :bar)
true

julia> hasproperty(Foo, :bar) # ibid
false

julia> hasproperty(Foo(1), :bar)
true

julia> hasfield(Foo, :bar) # hasfield checks if the type Foo has the field `bar`
true
```

One can also get just the number of fields a `DataType` has:
```julia
nfields(T) # or Base.datatype_nfields(T)
```

### Union Types

This is a simple function which extracts each type from a `Union` type:
```julia
julia> T = Union{Int8, Int32, Int64}
Union{Int32, Int64, Int8}

julia> Base.uniontypes(T)
3-element Vector{Any}:
 Int32
 Int64
 Int8
```

### Local evaluation of variables

It is common knowledge in the metaprogramming community of Julia that evaluating variables only happen at the global scope;
```julia
julia> x = 3
3

julia> eval(:x)
3

julia> foo(y) = eval(:y)
foo (generic function with 1 method)

julia> foo(3)
ERROR: UndefVarError: y not defined
```

Hence, there is a very convenient macro which can be used: `Base.@locals`.  This will show all of the local variables within the current scope.

## Applications

The problem that prompted me to learn a lot of the above: How might one get a function's 