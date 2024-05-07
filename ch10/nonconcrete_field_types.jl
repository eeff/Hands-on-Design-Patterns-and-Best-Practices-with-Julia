using Statistics: mean
using Bench

# field types are non-concrete (implicitly as `Any` in this case)
# the compiler use pointers to reference the actual field value
struct PointAny
    x
    y
end

struct Point{T<:Real}
    x::T
    y::T
end

print_size(T::Type) = println("$(T) size: $(sizeof(T))")

print_size(Point{UInt8})
print_size(Point{Int})
print_size(Point{Int128})
print_size(PointAny)

function center(points::AbstractVector{T}) where {T}
    T(trunc(mean(p.x for p in points)), trunc(mean(p.y for p in points)))
end

make_points(T::Type, n) = [T(rand(UInt8), rand(UInt8)) for _ in 1:n]

points_any = make_points(PointAny, 100_000)
points_uint8 = make_points(Point{UInt8}, 100_000)
points_int = make_points(Point{Int}, 100_000)

# concrete field types should perform better
@bench begin
    center($points_any)
    center($points_uint8)
    center($points_int)
end
