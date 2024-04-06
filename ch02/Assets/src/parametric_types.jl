struct StockHolding{T<:Real}
    stock::Stock
    quantity::T
end

struct StockHolding2{T<:Real,P<:AbstractFloat}
    stock::Stock
    quantity::T
    price::P
    marketvalue::P
end

abstract type Holding{P} end

struct StockHolding3{T,P} <: Holding{P}
    stock::Stock
    quantity::T
    price::P
    marketvalue::P
end

struct CacheHolding{P} <: Holding{P}
    currency::String
    amount::P
    marketvalue::P
end
