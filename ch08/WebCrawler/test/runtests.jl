using WebCrawler
using Test

@testset "WebCrawler.jl" begin
    add_site!(Target(; url="http://cnn.com"))
    add_site!(Target(; url="http://yahoo.com"))

    @test 2 == length(current_sites())
    # private variables and functions are hidden away
    @test_throws "Undef" WebCrawler.sites
    @test_throws "Undef" WebCrawler.index_site!()

    crawl_sites!()
    for s in current_sites()
        @test s.finished
    end
end
