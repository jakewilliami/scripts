#!/bin/bash
	#=
	exec julia --project="~/scripts/julia/Cryptography/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
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
		
Defences:
	- Hash function
=#

# p = 53
# q = 107
# d = 75
# M = 2001
# varM = 1720
# varDS = 873

p = parse(BigInt, ARGS[1]) # BigInt to avoid any overflow
q = parse(BigInt, ARGS[2])
d = parse(BigInt, ARGS[3])
M = parse(BigInt, ARGS[4])
varM = 1 # defaul (global) values to fall back on
varDS = 1

if isequal(length(ARGS), 6)
	varM = parse(BigInt, ARGS[5])
	varDS = parse(BigInt, ARGS[6])
end

function checkD(d::Integer, p::Integer, q::Integer)
	# check if d is prime to (p-1)(q-1)
	# can also use IsPrimeFermat.jl to calculate this
	
	if isone(gcd((p-1)*(q-1), d))
		return "d is good; it is prime to (p-1)(q-1)"
	else
		return "d is not good; not prime to (p-1)(q-1)"
	end
end


function getPubKey(d::Integer, p::Integer, q::Integer)
	# Bob recieves public key (e, n)
	
	e = invmod(d, (p-1)*(q-1))
	
	return (e, p*q)
end


function getCiphertext(M::Integer, d::Integer, p::Integer, q::Integer)
	#=
	Bob:
		- Recieves public key (e, n)
		- Writes message M in plaintext
		- Encrypts message C = M^e (mod n)
	=#
	
	e = invmod(d, (p-1)*(q-1)) # from getPubKey
	
	C = mod(M^e, p*q)
	
	return C
end


function decryptCiphertext(M::Integer, d::Integer, p::Integer, q::Integer)
	#=
	Alice:
		- Receives C
		- Decrypts M \== C^d (mod n)
	=#
	
	C = getCiphertext(M, d, p, q)
	
	M = mod(C^d, p*q)
end


function signMessage(M::Integer, d::Integer, p::Integer, q::Integer)
	DS = mod(M^d, p*q)
	
	return (M, DS)
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
		return true #"Alice sent the message"
	else
		return false #"Fred is up to no good"
	end # end if
end

println("Given n=$p×$q, is d=$d a good decryption key?")
output = checkD(d, p, q)
println("\t", output, "\n")

println("What is the public key (e, n) that Alice sends to Bob?")
output = getPubKey(d, p, q)
println("\t", output, "\n")

println("What is the ciphertext Bob computes from M=$M?")
output = getCiphertext(M, d, p, q)
println("\t", output, "\n")

println("When alice receives ciphertext C=$output, what message does she get back?")
output = decryptCiphertext(M, d, p, q)
println("\t", output, "\n")

println("Suppose M=$M.  What is the (M, DS(M)) that Alice sends to Bob?")
output = signMessage(M, d, p, q)
println("\t", output, "\n")

println("Given M=$varM, DS=$varDS, how does Bob know this message was from Alice?  *Was* it from Alice?  Is DS(M)^e = M?")
output = verifySignature(M, d, p, q)
println("\t", output)
