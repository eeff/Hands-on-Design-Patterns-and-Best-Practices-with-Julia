using LazyFiles
using Test

@testset "LazyFiles.jl" begin
    path = "/etc/hosts"
    fc = FileContent(path)

    @test path == fc.path
    @test missing !== fc.contents
    @test_throws "unsupported property" fc.loaded
    @test_throws "cannot be changed" fc.loaded = true
    @test_throws "cannot be changed" fc.contents = true

    old_contents = fc.contents
    fc.path = "/etc/profile"
    @test path != fc.path
    @test missing !== fc.contents
    @test length(old_contents) != length(fc.contents) || old_contents .!= fc.contents
end
