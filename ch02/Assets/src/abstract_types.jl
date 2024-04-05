abstract type Asset end

describe(a::Asset) = "Something valuable"

abstract type Property <: Asset end

describe(p::Property) = "Physical property"

"""
  location(p::Property)

Returns the location of the property as a tuple (latitude, longitude).
"""
location(p::Property) = error("Location is not implemented")

"""
  walking_distance(p1::Property, p2::Property)

Returns the walking distance between any two properties.
"""
function walking_distance(p1::Property, p2::Property)
    l1, l2 = location(p1), location(p2)
    return abs(l1.x - l2.x) + abs(l1.y - l2.y)
end

abstract type Investment <: Asset end

describe(i::Investment) = "Financial investment"

abstract type Cash <: Asset end

abstract type Apartment <: Property end
abstract type House <: Property end

abstract type Equity <: Investment end
abstract type FixedIncome <: Investment end

"""
Display the entire type hierarchy starting from the specified `type`.
"""
function subtypetree(type, level=0, indent=4, io=stdout, visited=Set{Type}())
    if type ∈ visited
        println(io, " "^(level * indent), type, "↺")
        return nothing
    end
    println(io, " "^(level * indent), type)
    push!(visited, type)
    for s in subtypes(type)
        subtypetree(s, level + 1, indent, io, visited)
    end
end
