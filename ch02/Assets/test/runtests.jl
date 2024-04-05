using Assets
using Test

@testset "Assets.jl" begin
    stock = Stock("APPL", "Apple, Inc.")
    @test occursin(stock.symbol, describe(stock))

    # composite types are by default immutable
    @test_throws "immutable" stock.company = "Apple LCC"

    many_stocks = [Stock("APPL", "Apple, Inc."), Stock("IBM", "IBM")]
    basket = BasketOfStocks(many_stocks, "Anniversary gift")
    # immutability stops at the field level
    pop!(basket.stocks)
    @test 1 == length(basket.stocks)

    monalisa = Painting("Leonardo da Vinci", "Monalisa")
    # element type of the array in front of the square brackets
    things = Thing[stock, monalisa]
    present = BasketOfThing(things, "Anniversary gift")

    # isa operator, infix
    @test stock isa Asset
    @test stock isa Investment
    # isa operator, function call
    @test isa(stock, Equity)

    # <: operator, infix
    @test Stock <: Asset
    @test Stock <: Investment
    # <: operator, function call
    @test <:(Stock,Equity)
    @test <:(Stock,Stock)
end
