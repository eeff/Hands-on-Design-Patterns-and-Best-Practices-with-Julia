using HackerNewsAnalysis
using Bench
using Test

@testset "HackerNewsAnalysis.jl" begin
    @test 0 != top_story_id()
    @test "" != top_story_title()
    @test average_score(10) > 0
    check_hotness(10)
end

xs = collect(1:10000)

add1v(xs) = [x + 1 for x in xs]
mul2v(xs) = [x * 2 for x in xs]

add1(x) = x + 1
mul2(x) = x * 2

# broadcasting avoids allocation of intermediate results, thus improve performance
@bench begin
    xs |> add1v |> mul2v
    xs .|> add1 .|> mul2
end
