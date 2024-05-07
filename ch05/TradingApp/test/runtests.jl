using TradingApp
using Dates
using Test

@testset "TradingApp.jl" begin
    stock = Stock("APPL", "Apple Inc")
    option = StockOption("AAPLC", Call, 200, Date(2019, 12, 20))

    @test 18800.0 == SingleTrade(Long, stock, 100, 188.0) |> payment
    @test 350.0 == SingleTrade(Long, option, 1, 3.5) |> payment

    pt = PairTrade(SingleTrade(Long, stock, 100, 188.0), SingleTrade(Short, option, 1, 3.5))
    @test 18450.0 == payment(pt)
end
