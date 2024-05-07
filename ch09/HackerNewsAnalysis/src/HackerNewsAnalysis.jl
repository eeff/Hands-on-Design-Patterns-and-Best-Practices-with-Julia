module HackerNewsAnalysis

export Story,
    fetch_top_stories,
    fetch_story,
    average_score,
    top_story,
    top_story_id,
    top_story_title,
    check_hotness

using Dates: now
using Formatting: printfmtln
using HTTP
using JSON3
using Statistics: mean

Base.@kwdef struct Story
    by::String
    descendants::Union{Int,Nothing} = nothing
    score::Int
    time::Int
    id::Int
    title::String
    kids::Union{Vector{Int},Nothing} = nothing
    url::Union{String,Nothing} = nothing
end

function Story(obj)
    Story(; obj...)
end

title(s::Story) = s.title

function fetch_top_stories()
    url = "https://hacker-news.firebaseio.com/v0/topstories.json"
    response = HTTP.request("GET", url)
    JSON3.read(response.body)
end

function fetch_story(id)
    url = "https://hacker-news.firebaseio.com/v0/item/$(id).json"
    response = HTTP.request("GET", url)
    data = JSON3.read(response.body)
    Story(; (key => get(data, key, nothing) for key in fieldnames(Story))...)
end

logx(fmt::AbstractString, f::Function=identity) = x -> begin
    let y = f(x)
        print(now(), " ")
        printfmtln(fmt, y)
    end
    x
end

take(n) = xs -> xs[1:min(n, end)]

calculate_average_score(stories) = mean(s.score for s in stories)

function average_score(n=10)
    fetch_top_stories() |>
    logx("Number of top stories = {}", length) |>
    take(n) |>
    logx("Limited number of stories = {}", length) .|>
    fetch_story |>
    logx("Fetch {} story details", length) |>
    calculate_average_score |>
    logx("Average score = {}")
end

hotness(score) = score > 100 ? Val(:high) : Val(:low)

celebrate(v::Val{:high}) = logx("Woohoo! Lots of hot topics!")(v)
celebrate(v::Val{:low}) = logx("It's just a normal day...")(v)

check_hotness(n=10) = average_score(n) |> hotness |> celebrate

top_story_id = first ∘ fetch_top_stories

top_story = fetch_story ∘ top_story_id

top_story_title = title ∘ top_story

end
