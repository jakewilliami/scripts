import Base: isvalid

TRY = 5
CONVERSION = 2
PENALTY = 3

struct Score
    value::UInt32
end
Score(S::T) where {T <: Integer} = Score(UInt32(S))

"""
```julia
isvalid(::Score) -> Bool
```

The `Score` struct represents a score in the game rugby.  The `isvalid` function checks if the value of that score is a valid score in a game of rugby (i.e., can be constructed within the confines of the rules of rugby).

For this function to return true, one of five things must be true:
  1. ``s = 3⋅p``
  2. ``s = 5⋅t``
  3. ``s = 5⋅t + 2⋅c`` where ``c ≤ t``
  4. ``s = 5⋅t + 3⋅p``
  5. ``s = 5⋅t + 2⋅c + 3⋅p`` where ``c ≤ t``
Where—:
  - ``s`` is the score,
  - ``t`` is the number of tries scored,
  - ``c`` is the number of conversions scored, and
  - ``p`` is the number of penalties scored.

Warning: it is not perfect.  I could have a score of 10, and I could assert that I got 5 conversions...well, obviously that cannot be so, so the algorithm would probably assume you got 2 tries.  It checks if a score *can* be valid.
"""
function isvalid(S::Score)
    score = S.value
    
    # no score is possible
    if iszero(score)
        return true
    end
    
    # the obvious base case is to ensure the score is not
    # less than a penalty (the lowest score)
    if score < PENALTY
        return false
    end
    
    # if the score can only consist of trys or penalties
    # then the score is valid
    # this checking (1) and (2)
    if iszero(mod(score, TRY)) || iszero(mod(score, PENALTY))
        return true
    end
    
    # if you have some number of tries, and the remainder
    # is divisible by 2, then the remainder can be conversions
    # note that the number of conversions has to be less than
    # the number of tries
    # this is checking (3)
    tries, remainder = divrem(score, TRY)
    if tries > 0
        for t in tries:-1:1
            new_remainder = score - (TRY * t)
            if iszero(mod(new_remainder, CONVERSION)) && (new_remainder ÷ CONVERSION) ≤ tries
                return true
            end
        end
    end
    
    # same concept as above
    # this is checking (4)
    if tries > 0
        for t in tries:-1:1
            new_remainder = score - (TRY * t)
            if iszero(mod(new_remainder, PENALTY))
                return true
            end
        end
    end
    
    # finally (and most difficult-ly) we need to check if
    # the score can be a combination of tries, conversions,
    # *and* penalties
    # this is checking (5)
    if (TRY + CONVERSION + PENALTY) < score
        for t in 1:ceil(Int, score / TRY)
            for c in 1:ceil(Int, score / CONVERSION)
                for p in 1:ceil(Int, score / PENALTY)
                    if isequal((TRY * t + CONVERSION * c + PENALTY * p), score)
                        return true
                    end
                end
            end
        end
    end
    
    # all other possibilities are accounted for, therefore
    # it cannot be a valid score
    return false
end
