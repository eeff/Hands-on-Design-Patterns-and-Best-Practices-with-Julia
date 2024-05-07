using CommandProcessor
using Bench
using Test

@testset "CommandProcessor.jl" begin
    CommandProcessor.process_command(::Command{:edit}, filename) =
        println("editing file $filename")

    process_command("open", "/etc/hosts")
    process_command("edit", "/etc/hosts")
    process_command("close", "/etc/hosts")
end

id(x) = x

@bench begin
    ntuple(id, 10)
    ntuple(id, 11)
    ntuple(id, 100)
    ntuple(id, Val(10))
    ntuple(id, Val(11))
    ntuple(id, Val(100))
    tuple((i for i in 1:10)...)
    tuple((i for i in 1:11)...)
    tuple((i for i in 1:100)...)
    tuple([i for i in 1:10]...)
    tuple([i for i in 1:11]...)
    tuple([i for i in 1:100]...)
    Tuple(i for i in 1:10)
    Tuple(i for i in 1:11)
    Tuple(i for i in 1:100)
    Tuple([i for i in 1:10])
    Tuple([i for i in 1:11])
    Tuple([i for i in 1:100])
end
