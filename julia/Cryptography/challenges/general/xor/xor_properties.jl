#=
Commutative: A ⊕ B = B ⊕ A
Associative: A ⊕ (B ⊕ C) = (A ⊕ B) ⊕ C
Identity: A ⊕ 0 = A
Self-Inverse: A ⊕ A = 0
=#
#=
KEY1 = a6c8b6733c9b22de7bc0253266a3867df55acde8635e19c73313
KEY2 ⊻ KEY1 = 37dcb292030faa90d07eec17e3b1c6d8daf94c35d4c9191a5e1e
KEY2 ⊻ KEY3 = c1545756687e7573db23aa1c3452a098b71a7fbf0fddddde5fc1
FLAG ⊻ KEY1 ⊻ KEY3 ⊻ KEY2 = 04ee9855208a2cd59091d04767ae47963170d1660df7f56f5faf 
=#
K1 = hex2bytes("a6c8b6733c9b22de7bc0253266a3867df55acde8635e19c73313")
K2vK1 = hex2bytes("37dcb292030faa90d07eec17e3b1c6d8daf94c35d4c9191a5e1e")
K2vK3 = hex2bytes("c1545756687e7573db23aa1c3452a098b71a7fbf0fddddde5fc1")
FvK1vK3vK2 = hex2bytes("04ee9855208a2cd59091d04767ae47963170d1660df7f56f5faf")

K1vK2vK3 = K2vK3 .⊻ K1
F = FvK1vK3vK2 .⊻ K1vK2vK3

println(String(F))

