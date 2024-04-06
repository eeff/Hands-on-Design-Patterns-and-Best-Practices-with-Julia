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

    holding = StockHolding(stock, 100)
    # echo parametric type variation is a different type
    @test StockHolding{Int} == typeof(holding)
    holding = StockHolding(stock, 100.0)
    @test StockHolding{Float64} == typeof(holding)
    holding = StockHolding(stock, 100//3)
    @test StockHolding{Rational{Int}} == typeof(holding)

    holding = StockHolding2(stock, 100, 180.0, 18000.0)
    @test StockHolding2{Int,Float64} == typeof(holding)
    # cannot deduce type `P`
    @test_throws "MethodError" StockHolding2(stock, 100, 180.0, 18000)

    certificate_in_the_safe = StockHolding3(stock, 100, 180.0, 18000.0)
    @test StockHolding3{Int,Float64} == typeof(certificate_in_the_safe)
    @test certificate_in_the_safe isa Holding
    @test certificate_in_the_safe isa Holding{Float64}
    @test !(certificate_in_the_safe isa Holding{Int})
    @test Holding{Float64} <: Holding
    @test Holding{Int} <: Holding
    @test StockHolding3{Int,Float64} <: Holding
    @test StockHolding3{Int,Float64} <: Holding{Float64}
    # not covariant
    @test !(StockHolding3{Int,Float64} <: Holding{AbstractFloat})
end
