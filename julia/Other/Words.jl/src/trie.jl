struct TrieNode
    child::Dict
    words::Vector
    
    function TrieNode()
        new(Dict(), [])
    end
end

function insert(root::TrieNode, word, original_word)
    curr = root
    for c in word
        curr.child[c] = get(curr.child, c, TrieNode())
        curr = curr.child[c]
    end
    
    push!(curr.words, original_word)
end

function print_anagrams(root::TrieNode)
    root == nothing && return
    if !isempty()
end
