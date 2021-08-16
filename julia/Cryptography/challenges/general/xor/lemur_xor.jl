# UNFINISHED

using Images, FileIO

lemur_img = load("lemur.png")
flag_img = load("flag.png")

size(lemur_img) != size(flag_img) && error("Cannot XOR images of different sizes")

# for ((i, j), b1) in enumerate(lemur_img)
    # b2 = flag_img[i, j]

flag_img
    
