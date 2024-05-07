module Bench

using BenchmarkTools
using PrettyTables: pretty_table
using Printf: @sprintf

export @bench

function meantime(t::BenchmarkTools.Trial)
    e = mean(t)
    time(e), gctime(e), memory(e), allocs(e)
end

macro row(ex)
    case = "$ex"
    Expr(:row, case, :(Bench.meantime(Bench.@benchmark $ex)...)) |> esc
end

macro bench(ex)
    @assert ex.head == :block
    data = Expr(:vcat)
    for e in ex.args
        if e isa Expr
            row = :(Bench.@row $(e)) |> esc
            push!(data.args, row)
        end
    end
    :(print_table($data))
end

# align decimal point
formatter(v, i, j) = v isa AbstractFloat ? @sprintf("%8.2f", v) : v

print_table(data) = pretty_table(
    data;
    header=["Case", "Time (ns)", "GCTime (ns)", "Memory (bytes)", "Allocs"],
    formatters=formatter,
)

end
