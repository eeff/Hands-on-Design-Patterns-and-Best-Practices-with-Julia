module TaxiTrips

using CSV

export Fare, TripPayment, read_trip_payment_file

struct Fare
    fare_amount::Float64
    extra::Float64
    mta_tax::Float64
    tip_amount::Float64
    tolls_amount::Float64
    improvement_surcharge::Float64
    total_amount::Float64
end

struct TripPayment
    vendor_id::Int
    tpep_pickup_datetime::String
    tpep_dropoff_datetime::String
    passenger_count::Int
    trip_distance::Float64
    fare::Fare
end

function read_trip_payment_file(file)
    f = CSV.File(file, skipto = 3)
    records = Vector{TripPayment}(undef, length(f))
    for (i, row) in enumerate(f)
        records[i] = TripPayment(
            row.VendorID,
            row.tpep_pickup_datetime,
            row.tpep_dropoff_datetime,
            row.passenger_count,
            row.trip_distance,
            Fare(
                row.fare_amount,
                row.extra,
                row.mta_tax,
                row.tip_amount,
                row.tolls_amount,
                row.improvement_surcharge,
                row.total_amount,
            ),
        )
    end
    records
end

end
