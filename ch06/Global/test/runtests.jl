using Global
using Bench

@bench begin
    add_using_global_variable(10)
    add_using_function_arg(10, 10)
    add_using_global_constant(10)
    add_using_global_variable_typed(10)
    add_by_passing_global_variable(10, $(Global.variable))
    add_using_global_semi_constant(10)
end
