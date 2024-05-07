module GUIFactories

export make_button, make_label

abstract type OS end
struct Windows <: OS end
struct Linux <: OS end

abstract type Button end

Base.show(io::IO, b::Button) = print(io, "'$(b.text)' button")

abstract type Label end

Base.show(io::IO, l::Label) = print(io, "'$(l.text)' label")

struct WindowsButton <: Button
    text::AbstractString
end

struct WindowsLabel <: Label
    text::AbstractString
end

struct LinuxButton <: Button
    text::AbstractString
end

struct LinuxLabel <: Label
    text::AbstractString
end

# Generic implementation using traits
current_os() = Linux()
make_button(text::AbstractString) = make_button(current_os(), text)
make_label(text::AbstractString) = make_label(current_os(), text)

# Windows implementation
make_button(::Windows, text::AbstractString) = WindowsButton(text)
make_label(::Windows, text::AbstractString) = WindowsLabel(text)

# Linux implementation
make_button(::Linux, text::AbstractString) = LinuxButton(text)
make_label(::Linux, text::AbstractString) = LinuxLabel(text)

end
