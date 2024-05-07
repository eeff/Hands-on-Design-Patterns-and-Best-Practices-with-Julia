module TradingApp

using Dates: Date

export Asset,
    Investment,
    Equity,
    Stock,
    CallPut,
    Call,
    PUT,
    StockOption,
    Trade,
    LongShort,
    Long,
    Short,
    SingleTrade,
    sign,
    payment,
    PairTrade

# abstract type hierarchy for personal assets
abstract type Asset end
abstract type Investment <: Asset end
abstract type Equity <: Investment end

# equity instruments types
struct Stock <: Equity
    symbol::String
    name::String
end

# type of stock options
@enum CallPut Call put

struct StockOption <: Equity
    symbol::String
    type::CallPut
    strike::Float64
    expiration::Date
end

# trading types
abstract type Trade end

# types (direction of the trade
@enum LongShort Long Short

struct SingleTrade{T<:Investment} <: Trade
    type::LongShort
    instrument::T
    quantity::Int
    price::Float64
end

# return + or - sign for the directionn of trade
function sign(t::SingleTrade{T}) where {T}
    return t.type == Long ? 1 : -1
end

# calculate payment amount for the trade
payment(t::SingleTrade{T}) where {T} = sign(t) * t.quantity * t.price
payment(t::SingleTrade{StockOption}) = sign(t) * t.quantity * 100 * t.price

struct PairTrade{T<:Investment,S<:Investment} <: Trade
    leg1::SingleTrade{T}
    leg2::SingleTrade{S}
end

payment(t::PairTrade) = payment(t.leg1) + payment(t.leg2)

end
