module Fibonacci

export fib_naive, fib_tail, fib_iter, fib_cache_dict, fib_cache_vec, fib_memo

# naive implementation, exponential runtime complexity
fib_naive(n) = n < 3 ? 1 : fib_naive(n - 1) + fib_naive(n - 2)

# tail recursive implementation, linear runtime complexity
fib_tail_(n, fₙ₋₁, fₙ₋₂) =
    if n == 1
        fₙ₋₂
    else
        fib_tail_(n - 1, fₙ₋₁ + fₙ₋₂, fₙ₋₁)
    end

function fib_tail(n)
    fib_tail_(n, 1, 1)
end

# iterative implementation, linear runtime complexity
function fib_iter(n)
    a, b = 1, 1
    for _ in 2:n
        a, b = b, a + b
    end
    a
end

# cache using dictionary, initialized with value of f₁ and f₂
const cache_dict = Dict(1 => 1, 2 => 1)

# memoization implementation using dictionary
function fib_cache_dict(n)
    if haskey(cache_dict, n)
        return cache_dict[n]
    else
        fₙ₋₁ = fib_cache_dict(n - 1)
        fₙ₋₂ = fib_cache_dict(n - 2)
        fₙ = fₙ₋₁ + fₙ₋₂
        cache_dict[n] = fₙ
        return fₙ
    end
end

# cache using vector, initialized with value of f₁ and f₂
const cache_vec = [1, 1]

fib_cache_vec_!(cache, n) =
    if cache[n] != 0
        cache[n]
    else
        fₙ₋₁ = fib_cache_vec_!(cache, n - 1)
        fₙ₋₂ = fib_cache_vec_!(cache, n - 2)
        fₙ = fₙ₋₁ + fₙ₋₂
        cache[n] = fₙ
    end

# memoization implementation using vector
function fib_cache_vec(n)
    m = length(cache_vec)
    if n > m
        sizehint!(cache_vec, n)
        append!(cache_vec, Base.Iterators.repeated(0, n - m))
    end
    fib_cache_vec_!(cache_vec, n)
end

# hash all arguments
function hash_all_args(args, kwargs)
    h = 0xed98007bd471dc2
    h += hash(args, h)
    h += hash(kwargs, h)
    h
end

# generic memoization supporting mutable function arguments
function memoize(f)
    memo = Dict()
    (args...; kwargs...) -> begin
        h = hash_all_args(args, kwargs)
        if haskey(memo, h)
            memo[h]
        else
            value = f(args...; kwargs...)
            memo[h] = value
            value
        end
    end
end

# if the function being memoized uses recursion, then it should be defined as anonymous function
fib_memo = n -> begin
    # println("fib_memo $(n)")
    n < 3 ? 1 : fib_memo(n - 1) + fib_memo(n - 2)
end

fib_memo = memoize(fib_memo)

end
