# MetaProgramming with Julia&mdash; some helpful results I have found

## Getting a function name

You can get a function name by obtaining the top level stacktrace.  The `stacktrace()` function will return a list of stacktrace frames, which is a type `Vector{Base.StackTraces.StackFrame}`.  `Base.StackTraces.StackFrame` has the properties `func, file, line, linfo, from_c, inlined, pointer`.  Importantly, the `func` property gives us the name of the function as a `Symbol`.

### Example

```julia
function foo()
	Base.StackTraces.stacktrace()[1]
end
```
```julia
julia> foo()
:foo
```

## Methods

Getting the methods of a function is well-known.  However, I only ever interactively read the results of `methods`.  Never had I actually parsed its results.  `methods` actually returns a type `Base.MethodList`, which has the fields `ms` (a list of methods, of type `Vector{Method}`), and `mt` (a `Core.MethodTable`).  The 
