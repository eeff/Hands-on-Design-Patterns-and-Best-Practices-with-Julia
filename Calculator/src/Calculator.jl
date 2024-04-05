module Calculator

export interest, rate

include("Mortgage.jl")
include("Banking.jl")

"""
interest(amount, rate)

Calculate interest from an `amount` and interest rate of `rate`.
"""
function interest(amount, rate)
    return amount * (1 + rate)
end

"""
rate(amount, interest)

Calculate interate rate based on an `amount` and `interest`.
"""
function rate(amount, interest)
    return interest / amount
end

end
