using LSystem
using Test

@testset "LSystem.jl" begin
    algae_model = LModel("A")
    add_rule!(algae_model, "A", "AB")
    add_rule!(algae_model, "B", "A")
    println(algae_model)

    state = LState(algae_model)
    println(state)
    state = next(state)
    println(state)
    state = next(state)
    println(state)
    state = next(state)
    println(state)
    state = next(state)
    println(state)

    println()

    algae_model = @lsys begin
        axiom:A
        rule:A → AB
        rule:B → A
    end
    println(algae_model)

    state = LState(algae_model)
    println(state)
    state = next(state)
    println(state)
    state = next(state)
    println(state)
    state = next(state)
    println(state)
    state = next(state)
    println(state)
end
