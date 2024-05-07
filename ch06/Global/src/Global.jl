module Global

export add_using_global_variable,
    add_using_function_arg,
    add_using_global_constant,
    add_using_global_variable_typed,
    add_by_passing_global_variable,
    add_using_global_semi_constant

# compiler generate slow code to access global variable, because it's type may change
# if global variable access costs more time than other operations, then performance hurts
variable = 10

function add_using_global_variable(x)
    variable + x
end

function add_using_function_arg(x, y)
    x + y
end

# global constant improve performance, because value and type does not change
const constant = 10

function add_using_global_constant(x)
    constant + x
end

# annotate the global variable type within the function improve performance
function add_using_global_variable_typed(x)
    variable::Int + x
end

function add_by_passing_global_variable(x, v)
    x + v
end

# a Ref object is nothing but a placeholder where the type of the enclosed object is known
const semi_constant = Ref(10) # RefValue{Int}

function add_using_global_semi_constant(x)
    semi_constant[] + x
end

end
