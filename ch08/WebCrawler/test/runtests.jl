using WebCrawler
using Test

@testset "WebCrawler.jl" begin
    add_site!(Target(; url="http://cnn.com"))
    add_site!(Target(; url="http://yahoo.com"))
    add_site!(Target(; url="http://goolge.com/page-does-not-exist"))

    @test 3 == length(current_sites())
    # private variables and functions are hidden away
    @test_throws "Undef" WebCrawler.sites
    @test_throws "Undef" WebCrawler.index_site!()

    crawl_sites!()
end
