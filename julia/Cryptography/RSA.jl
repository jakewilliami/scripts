#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Cryptography/" "${BASH_SOURCE[0]}" "$@" -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

#=
	e.g., ./Affine.jl "olwreglfelehnjjhmehlos" 7 5 27 d

	e.g., ./Affine.jl "maryhadalittlelamb" 19 5 26 e
=#


#n = parse(BigInt, ARGS[1])
#d = parse(Int, ARGS[1])
#e =

#if isequal(ARGS[@], )
#	n = parse(BigInt, ARGS[1])
#	d = parse(Int64, ARGS[2])
#	e = parse(Int64, ARGS[3])
#else

#end

#=
Basics: Alice and Bob want to communicate.  We want to avoid Eavesdropping Eve and Fraudulent Fred from interacting with the method.

RSA Process [encrypted to avoid Eve reading message]:
	Alice:
		- Computes p*q=n
		- Chooses d (mod (p-1)(q-1))
		- Computes e=invmod(d, (p-1)*(q-1))
	Bob:
		- Recieves public key (e, n)
		- Writes message M in plaintext
		- Encrypts message C = M^e (mod n)
	Alice:
		- Receives C
		- Decrypts M \== C^d (mod n)

RSA Process with Digital Signature DS [to avoid Fred pretending to be someone they are not]:
	Alice:
		- Writes a message M in plaintext (mod n)
		- Signs her message (not necessarily ciphertext, as Eve is no problem anymore): DS(M) \== M^d mod n
	Bob:
		- Receives (M, DS(M)), (n, e) # from the latter Tuple is the public key
		- Computes DS(M)^e.  Is this the same as M?  If it is, then the sender was Alice.


Attacks:
	- Quadratic sieves to factorise n
	- Universal Forgery (from Fred):
		* Fred chooses a random R mod n
		* Asks Alice to sign R*M and invmod(R, n)
		* Fred now computes DS(R*M) = (R*M)^d and DS(R^-1)=(R^-1)^d
		* Computes DS(R*M)*DS(R^-1) = M^d mod n = DS(M)
=#

p = 53
q = 107
# n = p*q
d = 75
M = 2001
varM = 1720
varDS = 873

function checkD(d::Integer, p::Integer, q::Integer)
	# check if d is prime to (p-1)(q-1)
	if isone(gcd((p-1)*(q-1), d))
		return "d is good; it is prime to (p-1)(q-1)"
	else
		return "d is not good; not prime to (p-1)(q-1)"
	end
end


function getPubKey(d::Integer, p::Integer, q::Integer)
	e = invmod(d, (p-1)*(q-1))
	return "Public key sent to Bob is", (e, p*q)
end


function signMessage(M::Integer, d::Integer, p::Integer, q::Integer)
	DS = mod(M^d, p*q)
	return "Message and signature sent to Bob is", (M, DS)
end

function verifySignature(M::Integer, d::Integer, p::Integer, q::Integer)
	#=
	Bob:
		- Receives (M, DS(M)), (n, e) # from the latter Tuple is the public key
		- Computes DS(M)^e.  Is this the same as M?  If it is, then the sender was Alice.
	=#
	
	M = varM
	DS = varDS
	
	e = invmod(d, (p-1)*(q-1)) # from getPubKey
		
	if isequal(M, mod(DS^e, p*q))
		return "Alice sent the message"
	else
		return "Fred is up to no good"
	end # end if
end

println("Given n=$p×$q, is d=$d a good decryption key?")
output = checkD(d, p, q)
println("\t", output, "\n")

println("What is the public key that Alice sends to Bob?")
output = getPubKey(d, p, q)
println("\t", output, "\n")

println("Suppose M=$M.  What is the DS(M) that Alice sends to Bob?")
output = signMessage(M, d, p, q)
println("\t", output, "\n")

println("Given M=$varM, DS=$varDS, how does Bob know this message was from Alice?  *Was* it from Alice?  Is DS(M)^e = M?")
output = verifySignature(M, d, p, q)
println("\t", output)
