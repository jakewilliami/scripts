#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e "include(popfirst!(ARGS))" \
    "${BASH_SOURCE[0]}" "$@"
    =#

#=
A goto programme can be coded by a single number!

For any d ∈ ℕ, the sequence code of a sequence (a0,a1,...,ad-1) ∈ ℕ^d, denoted by [a0,a1,...,ad-1], is
    ⟨d,⟨a0,a1,...,ad-1⟩⟩

Then, P is [a0,a1,...,ad-1].  So, given P, π(P, 2, 0, algebraic) is the number of lines of the programme, d;
and π(P, 2, 1, algebraic) is the programme itself.  Depairing that d times, we get a tuple of integers: the
instructions of the programme (one integer codes one line in the programme).

We define each line of the programme as being coded as follows:
 - The code for "Rn := Rn + 1" is ⟨0, n⟩;
 - The code for "Rn := Rn - 1" is ⟨1, n⟩;
 - The code for "goto k" is ⟨2, k⟩;
 - The code for "if Rn = 0 goto k" is ⟨3, ⟨n, k⟩⟩; and
 - The code for "halt" is ⟨4, 0⟩.
 
It should also be noted that the sequence code for some base cases is defined as follows:
 - if d = 0, the sequence code [] for the empty sequence is the number 0; and
 - if d = 1, for a ∈ ℕ, the sequence code [a] for the sequence (a) of length 1, is <1, a>.

=#
    
module GoToProgramme

include(joinpath(dirname(@__FILE__), "Coding.jl"))
using .Coding
using Printf: @printf

export Programme
export show_programme
export PairNTuple, π # exports from Coding.jl

struct Programme
    P::Integer
    p_length::Integer
    instructions::Vector{<:Tuple}
    max_line::Integer
    
    # declare constructor function
    function Programme(P::Integer)
        # Ensure the programme P is at least the nothing programme
        if P < PairNTuple(1, PairNTuple(4, 0))
            throw(error("The smallest possible programme is coded by ", PairNTuple(1, PairNTuple(4, 0)), "."))
        end
        
        # generate the snapshot of programme P
        snapshot = π(P, algebraic)
        p_length = snapshot[1]
        
        # construct list of codes for each instruction
        if iszero(p_length)  instruction_codes = 0  end
        instruction_codes = isone(p_length) ? snapshot[2] : π(snapshot[2], p_length, algebraic)
        
        # check that the programme halts at the end
        π(instruction_codes[end], algebraic) != (4, 0) && throw(error("Goto programmes neccesarily have a halting instruction."))
        
        # construct vector of tuples; each tuple represents a
        instructions = Vector()
        [instructions = [instructions..., π(i, algebraic)] for i in instruction_codes]
        
        max_line = length(instructions) - 1
        row_counter = -1 # need offset as we start counting from zero
        
        # check that all programme instruction codes are valid instructions
        for instruction in instructions
            primary_identifier = instruction[1]
            row_counter += 1
            
            if primary_identifier ∉ 0:4 || (isequal(primary_identifier, 4) && ! iszero(instruction[2]))
                throw(error("No known instruction for code ⟨$(join(instruction, ","))⟩"))
            end
            
            if isequal(primary_identifier, 4) && iszero(instruction[2]) && ! isequal(max_line, row_counter)
                throw(error("You must have exactly one halting instruction at the end of the programme."))
            end
            
            k = instruction[2]
            if isequal(primary_identifier, 2) && k > max_line
                throw(error("I cannot go to line $k of a programme which has $max_line instructions."))
            elseif isequal(primary_identifier, 2) && isequal(k, row_counter)
                throw(error("I am told to go to my own line (at line $k, goto line $k), and so I am stuck in an infinite loop.  The only way to escape is to tell you.  Please help me."))
            end
        end
        
        # construct fields
        new(P, p_length, instructions, max_line)
    end # end constructor (Programme) function
end # end struct

function show_programme(P::Programme)
    instructions = P.instructions
    max_line = P.max_line
    row_counter = -1
    message = ""
    
    for instruction in instructions
        primary_identifier = instruction[1]
        row_counter += 1
        
        if iszero(primary_identifier)
            n = instruction[2]
            message = "R$n := R$n + 1"
        elseif isone(primary_identifier)
            n = instruction[2]
            message = "R$n := R$n - 1"
        elseif isequal(primary_identifier, 2)
            k = instruction[2]
            message = "goto $k"
        elseif isequal(primary_identifier, 3)
            snapshot = π(instruction[2], algebraic)
            n = snapshot[1]
            k = snapshot[2]
            message = "if R$n = 0 goto $k"
        elseif isequal(primary_identifier, 4) && iszero(instruction[2])
            message = "halt"
        else
            message = "No known instruction for code ⟨$(join(instruction, ","))⟩"
        end
        
        @printf("%-3.3s  %-60.60s\n", "$row_counter", "$message")
    end
    
    return nothing
end # end show_programme function

# Given an integer, show_programme assumes it is a programme
show_programme(P::Integer) = show_programme(Programme(P))

end # end module


##############################################################################

# Testing

using .GoToProgramme

function test_random(d::Integer)
    # random = abs(rand(Int)) + 121
    random = rand(121:2000)
    
    println("The programme coded by the number $random is shown in $d instructions as follows:\n")
    
    show_programme(PairNTuple(d, PairNTuple(random, PairNTuple(4, 0))))
end

test_random(rand(1:20))



# show_programme(121) # nothing
# show_programme(5780) # increments R0
# show_programme(363183787614755732766753446033240) # R0 + R1
# show_programme(47647793381660617314792204840848041284799216315092916552372002176359491266052655618240826189604404499657821440865055594721546945013487153481242) # 2x
# show_programme(70412762139173751174325247391799151776337005517147051043631834182952422253779831226208595923309323737831968573315841128818823056224690660136852) # Halts ⟺ R0 > R1
# show_programme(972292871301644916468488152875266508938968846389326007980307063346008398713128885682044504108288931767348821063618087715644933567266540511345568504718733339523678538338052787779884557674350959673597803113281693069940562881722205193604550737455583875504348606989700013337656597740101535) # x is even
# show_programme(205730732633486384966622351453628834401467889726210346103959513051762547627139998617678896079541911717609887457732789857342022833705675563436609505478872937894576941059342053627889457145150696274821725679226065766050076065865969776160703392362855242197242113991347734260952068371852980421746576350307087653012602174765811026747786197090715942373501463406335611734154813409113036084192951558196867331326976234278185435603394663914919103613799112103533871665348284890539031694939769176178829018680241092841758658954528191264244932464536949946998435265503179733082285932644805209926424203038122780390914303728159394632286040419649009472657897768546426100127464810962485096768483347008408235989548976344038422501128743046003859572848248445166417047531554941786) # x = 3
