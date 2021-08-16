using Base64, Mods

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

PEM = readlines("privacy_enhanced_mail.pem")

delimiter_regex = r"-----[A-Z\s]+-----"

d = []
if occursin(delimiter_regex, PEM[1]) && occursin(delimiter_regex, PEM[end])
    b = join(PEM[2:(end - 1)])
    decoded = Base64.base64decode(b)
    
end


#=
s = Mod{10}(3); t = Mod{17}(5);

CRT(s, t)
=#
