using Sockets, JSON, Base64, ClassicalCiphers

HOST, PORT = ("socket.cryptohack.org", 13377)

function json_recv(tn::TCPSocket)
    line = readline(tn, keep = true)
    return JSON.parse(line)
end

function json_send(tn::TCPSocket, object::Dict)
    request = JSON.json(object)
    write(tn, request)
end

# see 13377.jl for the reversal of these
function decode_response(response::Dict)
    encoding = response["type"]
    value = response["encoded"]
    decoded = nothing
    
    if encoding == "base64"
        decoded = String(Base64.base64decode(value))
    elseif encoding == "hex"
        decoded = String(hex2bytes(value))
    elseif encoding == "rot13"
        decoded = decrypt_caesar(value, 13)
    elseif encoding == "bigint"
        decoded = String(hex2bytes(value[3:end]))
    elseif encoding == "utf-8"
        decoded = String(UInt8[UInt8(c) for c in value]) # equivalent to: `join(Char(a) for a in value)`
    end
    
    return decoded
end

# ===========================================

tn = connect(HOST, PORT)
received = json_recv(tn)

println("Received type: ")
println(received["type"])
println("Received encoded value: ")
println(received["encoded"])

decoded = decode_response(received)
println("Decoded response: ")
println(decoded)

to_send = Dict("decoded" => decoded)
json_send(tn, to_send)

println()

response = json_recv(tn)
println("Response type: ")
println(response["type"])
println("Response encoded: ")
println(response["encoded"])

decoded2 = decode_response(response)
println("Response decoded: ")
println(decoded2)
