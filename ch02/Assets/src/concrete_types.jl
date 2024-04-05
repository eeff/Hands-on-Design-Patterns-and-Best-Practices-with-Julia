struct Stock <: Equity
    symbol::String
    company::String
end

describe(s::Stock) = "$(s.symbol)($(s.company))"

struct BasketOfStocks
    stocks::Vector{Stock}
    reason::String
end

abstract type Art end

struct Painting <: Art
    artist::String
    title::String
end

const Thing = Union{Painting,Stock}

struct BasketOfThing
    things::Vector{Thing}
    reason::String
end
