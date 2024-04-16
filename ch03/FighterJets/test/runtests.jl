using Vehicle
using FighterJets
using Test

@testset "FighterJets.jl" begin
    fj = FighterJet(false, 0, (0, 0))
    go!(fj, :mars)
end
