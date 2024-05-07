module LSystem

export LModel, add_rule!, LState, next, @lsys

using MacroTools

struct LModel
    axioms::Vector{AbstractString}
    rules::Dict

    """Create a L-system model."""
    LModel(axiom) = new([axiom], Dict())
end

"""Add a rule to the model."""
function add_rule!(model::LModel, left::AbstractString, right::AbstractString)
    model.rules[left] = split(right, "")
    nothing
end

"""Display model nicely."""
function Base.show(io::IO, model::LModel)
    println(io, "LModel:")
    println(io, " Axiom: ", join(model.axioms))
    for k in sort(collect(keys(model.rules)))
        println(io, "  Rule: ", k, " →  ", join(model.rules[k]))
    end
end

struct LState
    model::LModel
    current_iteration::Int
    result::Vector{AbstractString}
end

"""Create a L-system state from a `model`."""
LState(model::LModel) = LState(model, 1, model.axioms)

"""Advance the next stage."""
function next(state::LState)
    new_result = []
    for left in state.result
        # just default to the element itself when it is not found
        right = get(state.model.rules, left, left)
        append!(new_result, right)
    end
    LState(state.model, state.current_iteration + 1, new_result)
end

"""Compact the result suitable for display."""
result(state::LState) = join(state.result)

Base.show(io::IO, s::LState) = print(io, "LState(", s.current_iteration, "): ", result(s))

macro lsys(ex)
    ex = MacroTools.postwalk(walk, ex)
    push!(ex.args, :(model))
    ex
end

function walk(ex)
    if @capture(ex, axiom:sym_)
        return :(model = LModel($(String(sym))))
    end
    if @capture(ex, rule:left_ → right_)
        return :(add_rule!(model, $(String(left)), $(String(right))))
    end
    ex
end

end
