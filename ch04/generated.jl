# generated functions accept types as arguments
@generated function doubled(x)
    if x <: AbstractFloat
        :(2.0 * x)
    else
        :(2 * x)
    end
end

println(doubled(2))
println(doubled(3.0))

