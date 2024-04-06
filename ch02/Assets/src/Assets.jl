module Assets

export Asset, Property, House, Apartment, Investment, FixedIncome, Equity, Cash
export describe, location, walking_distance, subtypetree
export Stock, BasketOfStocks, Art, Painting, BasketOfThing, Thing
export StockHolding, StockHolding2, StockHolding3, CacheHolding, Holding

include("abstract_types.jl")
include("concrete_types.jl")
include("parametric_types.jl")

end
