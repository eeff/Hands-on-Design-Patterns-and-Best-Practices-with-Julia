module CarBuilder

export Car, Engine, Wheels, Chassis, Builder, add, build

struct Engine
    model::String
end

struct Wheels
    model::String
end

struct Chassis
    model::String
end

struct Car
    engine::Engine
    wheels::Wheels
    chassis::Chassis
end

function Base.show(io::IO, c::Car)
    print(io, "Car $(c.engine)\n", "    $(c.wheels)\n", "    $(c.chassis)")
end

mutable struct Builder
    engine::Union{Engine,Missing}
    wheels::Union{Wheels,Missing}
    chassis::Union{Chassis,Missing}
end

Builder() = Builder(missing, missing, missing)

function build(b::Builder)
    if b.engine === missing
        error("engine missing")
    elseif b.wheels === missing
        error("wheels missing")
    elseif b.chassis === missing
        error("chassis missing")
    end

    Car(b.engine, b.wheels, b.chassis)
end

function add(engine::Engine)
    (b::Builder) -> begin
        b.engine = engine
        b
    end
end

function add(wheels::Wheels)
    (b::Builder) -> begin
        b.wheels = wheels
        b
    end
end

function add(chassis::Chassis)
    (b::Builder) -> begin
        b.chassis = chassis
        b
    end
end

end
