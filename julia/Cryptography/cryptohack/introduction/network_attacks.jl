using Sockets, JSON

HOST, PORT = ("socket.cryptohack.org", 11112)

function json_recv(tn::TCPSocket)
    line = readline(tn, keep = true)
    return JSON.parse(line)
end

function json_send(tn::TCPSocket, object::Dict)
    request = JSON.json(object)
    write(tn, request)
end

# ===========================================

tn = connect(HOST, PORT)

for _ in 1:4
    println(chomp(readline(tn, keep = true)))
end

# request = Dict("buy" => "clothes")
request = Dict("buy" => "flag")
json_send(tn, request)
response = json_recv(tn)

println(response)
