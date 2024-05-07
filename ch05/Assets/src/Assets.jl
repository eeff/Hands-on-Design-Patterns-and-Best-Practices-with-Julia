module Assets

export Asset,
    Property,
    Investment,
    Cash,
    House,
    Apartment,
    FixedIncome,
    Equity,
    Residence,
    Stock,
    TreasuryBill,
    Money,
    LiquidityStyle,
    IsLiquid,
    IsIlliquid,
    tradable,
    marketprice,
    Literature,
    Book

abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end

struct Residence <: House
    location
end

struct Stock <: Equity
    symbol
    name
end

struct TreasuryBill <: FixedIncome
    cusip
end

struct Money <: Cash
    currency
    amount
end

# traits are data types in julia

abstract type LiquidityStyle end
struct IsLiquid <: LiquidityStyle end
struct IsIlliquid <: LiquidityStyle end

# default behavior is illiquid
LiquidityStyle(::Type) = IsIlliquid()
# cash is always liquid
LiquidityStyle(::Type{<:Cash}) = IsLiquid()
# investments are liquid
LiquidityStyle(::Type{<:Investment}) = IsLiquid()

# the thing is tradable if it sliquid
tradable(x::T) where {T} = tradable(LiquidityStyle(T), x)
tradable(::IsLiquid, x) = true
tradable(::IsIlliquid, x) = false

# the thing has a market price if it is liquid
marketprice(x::T) where {T} = marketprice(LiquidityStyle(T), x)
marketprice(::IsLiquid, x) = error("Please implement pricing function for $(typeof(x))")
marketprice(::IsIlliquid, x) = error("Price for illiquid asset $x is not available.")

# sample pricing functino for Money and Stock
marketprice(x::Money) = x.amount
marketprice(x::Stock) = rand(200:250)

# using traits with a different type hierarchy

abstract type Literature end

struct Book <: Literature
    name
end

# trait implementation
LiquidityStyle(::Type{Book}) = IsLiquid()
marketprice(b::Book) = 10.0

end
