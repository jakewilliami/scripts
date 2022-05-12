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


function sleepsort!(V::Vector{T}) where {T <: Real}
    U = sort(V, SleepSort)
    for i in eachindex(V)
        V[i] = U[i]
    end
    return V
end

