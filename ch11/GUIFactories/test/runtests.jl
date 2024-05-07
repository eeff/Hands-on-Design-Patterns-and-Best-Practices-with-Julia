using GUIFactories
using Test

@testset "GUIFactories.jl" begin
    button = make_button("Click me")
    println(button)

    label = make_label("Hello")
    println(label)
end
