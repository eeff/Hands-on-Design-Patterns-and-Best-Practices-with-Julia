using SparseArrays
using Bench

# the most specific
sumprod_1(A::Vector{Float64}, B::Vector{Float64}) = sum(A .* B)

# only accept the exact type `Vector{Number}`, because parametric types are invariant,
# that is `Vector{Float64} <: Vector{Number} == false`
sumprod_2(A::Vector{Number}, B::Vector{Number}) = sum(A .* B)

# input vectors must have the same element type
sumprod_3(A::Vector{T}, B::Vector{T}) where {T<:Number} = sum(A .* B)

# input vectors could have the different element type that is some Number
sumprod_4(A::Vector{S}, B::Vector{T}) where {S<:Number,T<:Number} = sum(A .* B)

# supports dense array
sumprod_5(A::Array{S,N}, B::Array{T,N}) where {N,S<:Number,T<:Number} = sum(A .* B)

# support sparse array
function sumprod_6(
    A::AbstractArray{S,N}, B::AbstractArray{T,N}
) where {N,S<:Number,T<:Number}
    sum(A .* B)
end

# the most generic
sumprod_7(A, B) = sum(A .* B)

function test_harness(f, scenario, args...)
    try
        f(args...)
        println(" #$(scenario) success")
    catch ex
        if ex isa MethodError
            println(" #$(scenario) failure (method not selected)")
        else
            println(" #$(scenario) failure (unkown error $(ex))")
        end
    end
end

function test_sumprod(f)
    println("test $f")
    test_harness(f, 1, [1.0, 2.0], [3.0, 4.0])
    test_harness(f, 2, [1, 2], [3, 4])
    test_harness(f, 3, [1, 2], [3.0, 4.0])
    test_harness(f, 4, rand(2, 2), rand(2, 2))
    test_harness(f, 5, Number[1, 2.0], Number[3.0, 4])

    A = sparse([1, 10, 100], [1, 10, 100], [1, 2, 3])
    B = sparse([1, 10, 100], [1, 10, 100], [4, 5, 6])
    test_harness(f, 6, A, B)
end

test_sumprod(sumprod_1)
test_sumprod(sumprod_2)
test_sumprod(sumprod_3)
test_sumprod(sumprod_4)
test_sumprod(sumprod_5)
test_sumprod(sumprod_6)
test_sumprod(sumprod_7)

A = rand(10_000)
B = rand(10_000)

# how the argument types are specified does not affect runtime performance
@bench begin
    sumprod_1($A, $B)
    sumprod_5($A, $B)
    sumprod_6($A, $B)
    sumprod_7($A, $B)
end
