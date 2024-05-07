using Global
using BenchmarkTools
using PrettyTables: pretty_table
using Printf: @sprintf

function meantime(t::BenchmarkTools.Trial)
    e = mean(t)
    time(e), gctime(e), memory(e), allocs(e)
end

macro row(ex)
    case = String(ex.args[1])
    Expr(:row, case, :(meantime(@benchmark $(ex))...))
end

data = [
    @row add_using_global_variable(10)
    @row add_using_function_arg(10, 10)
    @row add_using_global_constant(10)
    @row add_using_global_variable_typed(10)
    @row add_by_passing_global_variable(10, $(Global.variable))
    @row add_using_global_semi_constant(10)
]

# align decimal point
formatter(v, i, j) = v isa AbstractFloat ? @sprintf("%8.2f", v) : v

pretty_table(
    data;
    header=["Case", "Time (ns)", "GCTime (ns)", "Memory (bytes)", "Allocs"],
    formatters=formatter,
)
