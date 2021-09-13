using Images, FileIO

# these are some functions to make XORing images simpler
# so that later we can get down to the business logic easily
function Base.xor(c1::RGB{N0f8}, c2::RGB{N0f8})
    r = reinterpret(N0f8, c1.r.i ⊻ c2.r.i)
    g = reinterpret(N0f8, c1.g.i ⊻ c2.g.i)
    b = reinterpret(N0f8, c1.b.i ⊻ c2.b.i)
    # rgb_vals_c1 = (c1.r.i, c1.g.i, c1.b.i)
    # rgb_vals_c2 = (c2.r.i, c2.g.i, c2.b.i)
    # rgb_vals_xored = (b1 ⊻ b2 for (b1, b2) in zip(rgb_vals_c1, rgb_vals_c2))
    # rgb_vals_n0f8 = (reinterpret(N0f8, b) for b in rgb_vals_xored)
    # return RGB{N0f8}(rgb_vals_n0f8...)
    return RGB{N0f8}(r, g, b)
end
function Base.xor(img1::Matrix{RGB{N0f8}}, img2::Matrix{RGB{N0f8}})
    size(img1) != size(img2) && error("Cannot XOR images of different sizes")
    img3 = zeros(RGB{N0f8}, size(img1))
    for i in CartesianIndices(img1)
        b1 = img1[i]
        b2 = img2[i]
        img3[i] = b1 ⊻ b2
    end 
    return img3
end

#############################################

# Load the images
lemur_img = load("lemur.png")
flag_img = load("flag.png")

# as both images were XORed with the same key, we can XOR them with each other 
# to get the key back; https://math.stackexchange.com/a/28957/705172
key = lemur_img ⊻ flag_img
save("key.png", key)
