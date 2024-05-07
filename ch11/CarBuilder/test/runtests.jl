using CarBuilder
using Test

@testset "CarBuilder.jl" begin
    car =
        Builder() |>
        add(Engine("4-cylinder 1600cc Engine")) |>
        add(Wheels("4x 20-inch wide wheels")) |>
        add(Chassis("Roadster Chassis")) |>
        build

    @test car isa Car

    println(car)
end
