module Assets

export Asset, Property, House, Apartment, Investment, FixedIncome, Equity, Cash
export describe, location, walking_distance, subtypetree
export Stock, BasketOfStocks, Art, Painting, BasketOfThing, Thing

include("abstract_types.jl")
include("concrete_types.jl")

end
