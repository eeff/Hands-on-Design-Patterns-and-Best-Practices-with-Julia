using SpaceWarGame
using Suppressor
using Test

module A

foo(x, y) = println("A.foo(x,y)")
foo(x::Integer, y) = println("A.foo(Integer, y)")
foo(x, y::Integer) = println("A.foo(x, Integer)")

end

module B

import ..A

A.foo(x::Integer, y::Integer) = println("B.foo(Integer, Integer)")

end

@testset "SpaceWarGame.jl" begin
    origin = Position(0, 0)
    w = Widget("asteroid", Position(0, 0), Size(10, 20))

    move_up!(w, 10)
    move_down!(w, 10)
    move_left!(w, 20)
    move_right!(w, 20)
    # should return to original position
    @test w.position == origin

    output = @capture_out println(w)
    @test contains(output, w.name)

    asteroids = make_asteroids(5)
    @test length(asteroids) == 5

    spaceship = Widget("Spaceship", Position(0, 0), Size(30, 30))
    target1 = asteroids[1]
    target2 = asteroids[2]
    target3 = asteroids[3]
    shoot(spaceship) # empty slurping
    shoot(spaceship, target1, target2, target3)

    spaceships = [Widget("Spaceship #$i", Position(0, 0), Size(20, 50)) for i in 1:3]
    triangular_formation!(spaceships...)
    @test spaceships[1].position == origin
    # excessive splatting causes no matching method
    @test_throws "no method" triangular_formation!([spaceships; spaceship]...)

    random_leap!(spaceship)
    println("random_leap, ", spaceship)
    @test spaceship.position != origin
    old_position = copy(spaceship.position)
    random_leap!(spaceship)
    println("random_leap, ", spaceship)
    @test spaceship.position != old_position

    fire(s -> println(s, " launched missile!"), spaceship)
    fire(spaceship) do s
        move_up!(s, 100)
        println(s, " launched missile!")
        move_down!(s, 100)
    end

    clean_up_galaxy(asteroids)

    s1 = Spaceship(Position(0, 0), Size(30, 5), Missile)
    s2 = Spaceship(Position(10, 0), Size(30, 5), Laser)
    a1 = Asteroid(Position(20, 0), Size(20, 20))
    a2 = Asteroid(Position(0, 20), Size(20, 20))
    @test SpaceWarGame.position(s1) == s1.position
    @test SpaceWarGame.size(s1) == s1.size
    @test shape(s1) == :saucer
    @test SpaceWarGame.position(a1) == a1.position
    @test SpaceWarGame.size(a1) == a1.size
    @test shape(a1) == :unknown

    @test collide(s1, s2)
    @test_throws "ambiguous" collide(a1, a2)
    @test length(detect_ambiguities(SpaceWarGame)) > 0

    # resolve ambiguities
    function SpaceWarGame.collide(a::Asteroid, b::Asteroid)
        println("Checking collision of ateroid vs. asteroid")
        return true
    end

    @test collide(a1, a2)
    @test length(detect_ambiguities(SpaceWarGame)) == 0

    function check_randomly(things)
        for i in 1:5
            two = rand(things, 2)
            collide(two...)
        end
    end

    check_randomly([s1, s2, a1, a2])

    A.foo(1, 2)
    @test length(detect_ambiguities(A)) == 0
    @test length(detect_ambiguities(A, B)) == 0

    explode([a1, a2])

    # specifying abstract/concrete types in method signature
    function tow(spaceship::Spaceship, thing::Thing)
        return println("tow")
    end

    @test length(methods(tow)) == 1

    # equivalent of parametric type
    # overwritten previous method
    function tow(spaceship::Spaceship, thing::T) where {T<:Thing}
        return println("tow")
    end

    @test length(methods(tow)) == 1

    group_anything(s1, s2)
    group_anything(a1, a2)
    group_anything(s1, a1)
    group_anything(a1, s1)
    group_same_thing(s1, s2)
    group_same_thing(a1, a2)
    @test_throws "no method" group_same_thing(s1, a1)
    @test_throws "no method" group_same_thing(a1, s1)
end
