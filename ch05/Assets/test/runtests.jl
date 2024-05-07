using Assets
using Test

@testset "Assets.jl" begin
    money = Money("USD", 100.00)
    @test tradable(money)
    @test 100.00 == marketprice(money)

    appl = Stock("APPL", "Apple, Inc.")
    @test tradable(appl)
    @test marketprice(appl) > 0

    home = Residence("Los Angeles")
    @test !tradable(home)
    @test_throws "not available" marketprice(home)

    bill = TreasuryBill("12356789")
    @test tradable(bill)
    @test_throws "Please implement pricing function" marketprice(bill)

    book = Book("Hands on Design Patterns and Best Practices with Julia")
    @test tradable(book)
    @test 10.0 == marketprice(book)
end
