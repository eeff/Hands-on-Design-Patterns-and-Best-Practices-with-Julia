using Fibonacci
using Bench
using Test

@testset "Fibonacci.jl" begin
    expected = 102334155
    @test expected == fib_naive(40)
    @test expected == fib_tail(40)
    @test expected == fib_memo(40)
    @test expected == fib_cache_dict(40)
    @test expected == fib_cache_vec(40)
    @test expected == fib_iter(40)
end

@bench begin
    fib_naive(40)
    fib_tail(40)
    fib_memo(40)
    fib_cache_dict(40)
    fib_cache_vec(40)
    fib_iter(40)
end
