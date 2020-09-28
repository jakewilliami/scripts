#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
e.g.
    ./UnpairingFunction.jl 3 17
=#


## TODO: Make depairing thruple more efficient

n = parse(Int, ARGS[1])
m = parse(BigInt, ARGS[2])


pairTuple(x::Integer, y::Integer)::BigInt = BigInt(x + binomial(x+y+1, 2))
pairTuple(x::Integer, y::Integer, z::Integer...)::BigInt = pairTuple(pairTuple(x, y), z...)


#=
    We can ``undo'' the pairing:  if m = < x, y >, then we let π0(m) = x and π1(m) = y.  In other words, first undo the pairing and then take the corres-ponding projection function.
    The functions π0 and π1 are also primitive recursive:  they are defined by bounded search, using bounded quantification.  The point is the following,which can be observed by the formula we gave:

    Lemma: ∀ x, y ∈ N, < x, y > ≥ x and < x, y > ≥ y.
    
    So π0(m) is the least z ≤ m such that there is some y ≤ m such that m = < x, y >.   Since  the  pairing  function  is  primitive  recursive,  its  graph (the relation z = < x, y >)  is  also  primitive  recursive.   We  then  use  closure of primitive recursive relations under bounded quantification and boundedsearch.  To sum up,
        π0(m) = (μx ≤ m)(∃y ≤ m)m = < x, y >
    and so π0 (and similarly π1) is primitive recursive.
=#
@generated function unpair_ntuple(::Val{n}, m::Integer) where {n}
    quote
        @inbounds @fastmath Base.Cartesian.@nloops $n i d -> 0:m begin
            if isequal(pairTuple((Base.Cartesian.@ntuple $n i)...), m)
                return Base.Cartesian.@ntuple $n i
            end
        end
    end
end

unpair_ntuple(n::Integer, m::Integer) = unpair_ntuple(Val(n), m)

ntuple_out = @time unpair_ntuple(n, m)
println("\t$m ⟼  < $ntuple_out >")


#=
@dmipeck's genius, not mine
=#
function iterative_unpair_ntuple(dimension::Integer, max::Integer)
    result::Array{Integer}=zeros(dimension)
    
    while pairTuple(result...) != max
        #increment array
        result[1] += 1
        for i in 1:dimension
            if result[i] > max
                if i == dimension
                    return nothing
                else
                    result[i+1] += 1
                    result[i] = 0
                end
            else
                break
            end
        end
    end
    
    return result
end


# suggested by /u/iagueqnar
function iterative_implementation(n::Integer, m::Integer)
    for idx in Iterators.product(repeat([0:m], n)...)
        args = Tuple(idx)
        if isequal(pairTuple(args...), m)
            return args
        end
    end
end


function genPlot()
    stop_n_at = 10
    stop_m_at = 10
    num_of_datapoints = 50
    data = Matrix{Union{AbstractFloat,Integer}}(undef,num_of_datapoints,5)# needs 5 columns: n; m; bonk time; doov time; iagueqnar time
    m_data = []

    # for n in 2:stop_n_at
    #     for m in 1:stop_m_at
    #         bonks = @elapsed unpair_ntuple(Val(n), m)
    #         doovs = @elapsed iterative_unpair_ntuple(n, m)
    #         data[m,:] .= [n, m, bonks, doovs]
    #     end
    # end
    
    for i in 1:num_of_datapoints
        n = rand(2:stop_n_at)
        m = rand(1:stop_m_at)
        bonks = @elapsed unpair_ntuple(Val(n), m)
        doovs = @elapsed iterative_unpair_ntuple(n, m)
        i_guys = @elapsed iterative_implementation(n, m)
        data[i,:] .= [n, m, bonks, doovs, i_guys]
    end

    # make n and m integers
    # data[1:2,:] .= convert(Integer, )
    # data[1:2,:] = [parse(BigInt, a) for a in ARGS]
    # data[:,1:2] .= convert.(Integer, data[:,1:2])
    # df = DataFrame(n = data[:,1], m = [:,2], bonk = [:,3], doov = [:,4])

    # displaymatrix(data)
    
    # x is n tuples with mean


    gr() # set plot backend
    theme(:solarized)
    
    # plot = scatter(data[:,1], data[:,3:4], smooth = true, fontfamily = font("Times"), xlabel = "n", ylabel = "Time elapsed during calculation [seconds]", label = ["Bonk's" "Doov's"])#, xlims = (0, stop_n_at))
    # savefig(plot, joinpath(homedir(), "Desktop", "doov_v_bonk,n=$stop_n_at,m=$stop_m_at,i=$num_of_datapoints.pdf"))
    
    plot = scatter(data[:,1], data[:,3:5], smooth = true, fontfamily = font("Times"), xlabel = "n", ylabel = "Time elapsed during calculation [seconds]", label = ["Bonk's" "Doov's" "iagueqnar"])#, xlims = (0, stop_n_at))
    savefig(plot, joinpath(dirname(@__FILE__), "unpairing", "doov_v_bonk_v_iagueqnar,n=$stop_n_at,m=$stop_m_at,i=$num_of_datapoints.pdf"))
end

# genPlot()
