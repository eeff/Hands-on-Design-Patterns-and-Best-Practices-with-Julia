module SpaceWarGame

export Position, Size, Widget
export move_up!, move_down!, move_left!, move_right!
export make_asteroids, shoot, triangular_formation!, random_leap!, clean_up_galaxy, fire

# Space war game

mutable struct Position
    x::Int
    y::Int
end

Base.:(==)(p1::Position, p2::Position) = p1.x == p2.x && p1.y == p2.y
Base.copy(p::Position) = Position(p.x, p.y)

struct Size
    width::Int
    height::Int
end

struct Widget
    name::String
    position::Position
    size::Size
end

Base.copy(w::Widget) = Widget(w.name, copy(w.position), w.size)

move_up!(widget::Widget, v::Int) = widget.position.y -= v
move_down!(widget::Widget, v::Int) = widget.position.y += v
move_left!(widget::Widget, v::Int) = widget.position.x -= v
move_right!(widget::Widget, v::Int) = widget.position.x += v

# Pretty print functions
Base.show(io::IO, p::Position) = print(io, "($(p.x),$(p.y))")
Base.show(io::IO, s::Size) = print(io, "$(s.width) x $(s.height)")
Base.show(io::IO, w::Widget) = print(io, w.name, " at ", w.position, " size ", w.size)

# Make a bunch of asteroids
function make_asteroids(N::Int; pos_range=0:200, size_range=10:30)
    rand_pos() = rand(pos_range)
    rand_sz() = rand(size_range)
    return [
        Widget(
            "Asteroid #$i", Position(rand_pos(), rand_pos()), Size(rand_sz(), rand_sz())
        ) for i in 1:N
    ]
end

# Shoot any number of targets
function shoot(from::Widget, targets::Widget...)
    println("Type of targets: ", typeof(targets))
    for target in targets
        println(from.name, " --> ", target.name)
    end
end

# Special arrangement before attacks
function triangular_formation!(s1::Widget, s2::Widget, s3::Widget)
    x_offset = 30
    y_offset = 50
    s2.position.x = s1.position.x - x_offset
    s3.position.x = s1.position.x + x_offset
    s2.position.y = s3.position.y = s1.position.y - y_offset
    return (s1, s2, s3)
end

function random_move()
    return rand([move_up!, move_down!, move_left!, move_right!])
end

function random_leap!(w::Widget; move::Function=random_move(), distance::Int=rand(1:100))
    move(w, distance)
    return w
end

function clean_up_galaxy(widgets)
    return foreach(w -> println(w, " exploded!"), widgets)
end

# Random healthiness function for testing
healthy(spaceship) = rand(Bool)

# Make sure the spaceship is healthy before any operation
function fire(f::Function, spaceship::Widget)
    if healthy(spaceship)
        f(spaceship)
    else
        println("Operation aborted as spaceship is not healthy")
    end
end

end