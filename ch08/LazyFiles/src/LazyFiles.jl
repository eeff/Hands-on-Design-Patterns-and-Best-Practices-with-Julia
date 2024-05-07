module LazyFiles

using Base: File
export FileContent

mutable struct FileContent
    path::AbstractString
    loaded::Bool
    contents::Union{Missing,Vector{UInt8}}
end

FileContent(path::AbstractString) = FileContent(path, false, missing)

function Base.getproperty(fc::FileContent, s::Symbol)
    passthrough_fields = (:path,)
    if s in passthrough_fields
        return getfield(fc, s)
    end
    if s === :contents
        !getfield(fc, :loaded) && load_contents!(fc)
        return getfield(fc, s)
    end
    error("unsupported property: $s")
end

function Base.setproperty!(fc::FileContent, s::Symbol, value)
    if s === :path
        setfield!(fc, s, value)
        setfield!(fc, :loaded, false)
        setfield!(fc, :contents, missing)
        return nothing
    end
    error("property $s cannot be changed.")
end

function Base.propertynames(fc::FileContent)
    (:path, :contents)
end

function load_contents!(fc::FileContent)
    path = getfield(fc, :path)
    open(path) do io
        ss = lstat(path)
        data = Vector{UInt8}(undef, ss.size)
        readbytes!(io, data)
        println("file $path (size $(ss.size)) loaded")
        setfield!(fc, :loaded, true)
        setfield!(fc, :contents, data)
    end
    nothing
end

end
