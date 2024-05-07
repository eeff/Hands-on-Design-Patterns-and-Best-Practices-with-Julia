using SingletonExample
using Test

# Pkg.test("SingletonExample"; julia_args=["--threads", "4"])
@testset "SingletonExample.jl" begin
    println("Number of threads: ", Threads.nthreads())
    Threads.@threads for i in 1:8
        SingletonExample.init()
    end
end
