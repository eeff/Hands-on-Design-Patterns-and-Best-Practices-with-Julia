using Barrier
using Bench
using Test

@testset "Barrier.jl" begin
    @test_nowarn @inferred double_sum(rand(Int, 10))
    @test_nowarn @inferred double_sum(rand(Float64, 10))
    @test_throws "not match inferred" @inferred double_sum_of_random_data_unstable(1)
    @test_throws "not match inferred" @inferred double_sum_of_random_data_barrier(1)
end

@bench begin
    double_sum_of_random_data_unstable(10000)
    double_sum_of_random_data_barrier(10000)
    double_sum_of_random_data_unstable(10001)
    double_sum_of_random_data_barrier(10001)
end
