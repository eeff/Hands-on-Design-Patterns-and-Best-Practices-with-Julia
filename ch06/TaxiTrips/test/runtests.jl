using TaxiTrips
using Statistics
using StructArrays
using Bench

const file = "../yellow_tripdata_2018-12_100k.csv"

records = read_trip_payment_file(file)
fare_amounts = [r.fare.fare_amount for r in records]

# columnar layout is more compact and the compiler can utilise SMID instructions
sa = StructArray(records; unwrap=t -> t <: Fare)

println("records size $(Base.summarysize(records)/1024/1024) MB")
println("     sa size $(Base.summarysize(sa)/1024/1024) MB")

# run with ```Pkg.test(julia_args=["--check-bounds-no"])```
@bench begin
    mean(r.fare.fare_amount for r in $(records))
    mean($(fare_amounts))
    mean($(sa.fare.fare_amount))
end
