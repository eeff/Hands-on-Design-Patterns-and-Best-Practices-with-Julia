module CommandProcessor

export Command, process_command

# a parametric singleton type that represents a specific command
struct Command{T} end

# constructor function to create a new Command from a string
Command(s::AbstractString) = Command{Symbol(s)}()

# dispatcher function
function process_command(cmd::AbstractString, args...)
    process_command(Command(cmd), args...)
end

function process_command(::Command{:open}, filename)
    println("opening file $filename")
end

function process_command(::Command{:close}, filename)
    println("closing file $filename")
end

end
