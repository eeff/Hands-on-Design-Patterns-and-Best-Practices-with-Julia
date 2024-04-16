macro hello(n)
    :(
        for i in 1:$n
            println("hello world")
        end
    )
end

# macro expansion result
println(@macroexpand @hello 3)

# macros are invoked with the following general syntax:
# @name expr1 expr2 ...
# @name(expr1, expr2, ...)

@hello 1
@hello(1)

# macro arguments may include expressions, literal values, and symbols

function showme(x)
    @show x
end

macro showme(x)
    @show x
end

a = 1
b = "hello"
c = :hello

showme(a)
showme(b)
showme(c)

@showme(a)
@showme(b)
@showme(c)

# macros are necessary because they execute when code is parsed,
# therefore, macros allow the programmer to generate and include fragments of customized code before the full program is run

macro identify(ex)
    dump(ex)
    ex
end

function foo()
    @identify 1 + 2 + 3
end

using InteractiveUtils: @code_lowered
println(@code_lowered foo())

# macro hygiene to keep generated code clean
# local variables are renamed to be unique (using the gensym function, which generates new symbols)
# global variables are resolved within the macro definition environment

macro squared(ex)
    :($ex * $ex)
end

function foo()
    x = 2
    @squared x
end

println(@code_lowered foo())

using Test
@test_throws "`x` not defined" foo()

# escaped expression is left alone by the macro expander and simply pasted into the output verbatim
# therefore it will be resolved in the macro call environment

macro squared(ex)
    :($(esc(ex)) * $(esc(ex)))
end

function foo()
    x = 2
    @squared x
end

println(@code_lowered foo())

@test 4 == foo()

# transform f(x) into f(f(x))
macro compose_twice(ex)
    @assert ex.head == :call
    @assert length(ex.args) == 2
    me = copy(ex)
    ex.args[2] = me
    ex
end

@test @compose_twice(sin(1)) == sin(sin(1))

# runs an expression `ex` for `n` times
macro ntimes(n, ex)
    quote
        times = $(esc(n))
        for i in 1:times
            $(esc(ex))
        end
    end
end

function foo()
    times = 0
    @ntimes 3 println("hello world")
    # macro hygiene ensures that the `time` variable is not polluted
    @assert times == 0
    println("times = ", times)
end

foo()

using DataFrames

# nonstandard string literals
macro ndf_str(s)
    nstr, spec = split(s, ":")
    nrows = parse(Int, nstr)
    types = split(spec, ",")
    ncols = length(types)
    mappings = Dict(
        "f64" => Float64, "f32" => Float32, "i64" => Int64, "i32" => Int32, "i16" => Int16, "i8" => Int8
    )
    col_types = [mappings[t] for t in types]
    col_names = [Symbol("x", i) for i in 1:ncols]
    DataFrame([col_names[i] => rand(col_types[i], ncols) for i in 1:ncols])
end

function foo()
    ndf = ndf"10:f64,f32,i16,i8"
    println("ndf literal address: ", pointer_from_objref(ndf))
    ndf
end


foo()
foo()
println(@code_lowered foo())
