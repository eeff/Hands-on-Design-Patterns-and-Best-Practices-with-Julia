# automatically defines the struct and the corresponding constructor function with keyword arguments
Base.@kwdef struct TextStyle
    font_family
    font_size
    font_weight = "Regular"
    foreground_color = "black"
    background_color = "white"
    alignment = "center"
    rotation = 0
end

println(methods(TextStyle))

style = TextStyle(font_family="Arial", font_size=11)
println(style)
