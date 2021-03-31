list = [2, 3, 3, 2, 4, 5, 4]

function findFreqDict(values)
    dict = Dict()
    counter, most_frequent = 0, nothing

    for i in sort(values, rev = true)
        dict[i] = get(dict, i, 0) + 1
        if dict[i] >= counter
            counter, most_frequent = dict[i], i
        end
    end

    return most_frequent, counter # most frequent element, and the number of times it occurred
end

println(findFreqDict(list))

