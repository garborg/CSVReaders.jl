function allocate{T}(
    ::Type{Vector{Nullable{T}}},
    nrows::Int,
    ncols::Int,
    reader::CSVReader,
)
    return Array(Nullable{T}, nrows * ncols)
end

function available_rows{T}(output::Vector{Nullable{T}}, reader::CSVReader)
    return fld(length(output), length(reader.column_names))
end

function add_rows!{T}(output::Vector{Nullable{T}}, nrows::Int, ncols::Int)
    resize!(output, nrows * ncols)
    return
end

function fix_type!{T}(
    output::Vector{Nullable{T}},
    i::Int,
    j::Int,
    code::Int,
    reader::CSVReader,
)
    if code > type2code(T)
        error(
            @sprintf(
                "%s cannot store a value of type %s",
                typeof(output),
                code2type(code),
            )
        )
    end
end

function store_null!{T}(
    output::Vector{Nullable{T}},
    i::Int,
    j::Int,
    reader::CSVReader,
)
    output[(i - 1) * length(reader.column_types) + j] = Nullable{T}()
    return
end

function store_value!{T}(
    output::Vector{Nullable{T}},
    i::Int,
    j::Int,
    reader::CSVReader,
    value::Any,
)
    output[(i - 1) * length(reader.column_types) + j] = Nullable{T}(value)
    return
end

function finalize{T}(output::Vector{Nullable{T}}, nrows::Int, ncols::Int)
    resize!(output, nrows * ncols)
    return output
end
