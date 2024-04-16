using SpaceWarGame
using Suppressor
using Test

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
end
