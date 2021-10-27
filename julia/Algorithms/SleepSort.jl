function sleepsort(V::Vector{T}) where {T <: Real}
    U = Vector{T}()
    sizehint!(U, length(V))
    @sync for v in V
        @async begin
            sleep(abs(v))
            (v < 0 ? pushfirst! : push!)(U, v)
        end
    end
    return U
end
