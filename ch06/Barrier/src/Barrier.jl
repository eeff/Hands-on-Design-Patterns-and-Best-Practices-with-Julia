module Barrier

export random_data,
    double_sum, double_sum_of_random_data_unstable, double_sum_of_random_data_barrier

random_data(n) = isodd(n) ? rand(Int, n) : rand(Float64, n)

function double_sum_of_random_data_unstable(n)
    data = random_data(n)
    total = zero(eltype(data))
    for v in data
        total += 2 * v
    end
    total
end

function double_sum(data)
    total = zero(eltype(data))
    for v in data
        total += v
    end
    total
end

function double_sum_of_random_data_barrier(n)
    data = random_data(n)
    double_sum(data)
end

end
