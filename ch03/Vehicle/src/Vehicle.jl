"""
Generic space travel logic.

Any vehicle (v) must implement the following functions:

power_on!(v) - turn on the vehicle's engine

power_off!(v) - turn off the vehicle's engine

turn!(v, direction) - steer the vehicle to the specified direction 

move!(v, distance) - move the vehicle by the specified distance

position(v) - returns the (x,y) position of the vehicle

"""
module Vehicle

# ------------------------------------------------------------------
# 1. Export/Imports
# ------------------------------------------------------------------
export go!

# ------------------------------------------------------------------
# 2. Generic definitions for the interface
# ------------------------------------------------------------------
"""
  power_on!(vehicle)

Power on the vehicle so it is ready to go.
"""
function power_on! end

"""
  power_off!(vehicle)

Power off the vehicle so it is stopped.
"""
function power_off! end

"""
  turn!(vehicle, direction)

Turn the vehicle to the specified direction.
"""
function turn! end

"""
  move!(vehicle, distance)

Move the vehicle a given distance.
"""
function move! end

"""
  position(vehicle)

Return the current position of the vehicle.
"""
function position end

# ------------------------------------------------------------------
# 3. Game logic
# ------------------------------------------------------------------

"""
    travel_path(position, destination)

Returns a travel plan from current position to destination.
"""
function travel_path(position, destination)
    round(π / 6; digits=2), 1000
end

"""
    go!(vehicle, destination)

Take the vehicle a space travel to the destination.
"""
function go!(vehicle, destination)
    power_on!(vehicle)
    direction, distance = travel_path(position(vehicle), destination)
    turn!(vehicle, direction)
    move!(vehicle, distance)
    power_off!(vehicle)
    nothing
end

end
