using Bank
using Dates
using Test

@testset "Bank.jl" begin
    number = "000000"
    money = 1000
    date = today()
    rate = 0.03

    sa = SavingsAccount(number, money, date, rate)

    @test number == account_number(sa)
    @test money == balance(sa)
    @test date == date_opened(sa)
    @test rate == interest_rate(sa)

    @test money + 10 == deposit!(sa, 10)
    @test money == withdraw!(sa, 10)
    @test 10 == transfer!(sa, sa, 10)
    @test 0 != accrue_daily_interest!(sa)
    @test money < balance(sa)
end
