#! /Library/Frameworks/Python.framework/Versions/3.7/bin/python3

import numpy as np
from PIL import Image, ImageDraw, ImageFont
import PIL.ImageOps

# define globals
sz = (180, 180)
msg = 'J'
fontstyle, fontsize = ('/Library/Fonts/Georgia Bold.ttf', 144)
yshift = 10 # need this for 'J' to sit above line

def create_icon(back_colour, font_colour, sz, msg, fontstyle, fontsize, yshift):
    W, H = sz
    # create image
    img = Image.new('RGB', (W, H), color = back_colour)
    # define font
    fnt = ImageFont.truetype(fontstyle, fontsize)
    d = ImageDraw.Draw(img)

    # get size of letter
    w, h = fnt.getsize(msg)
    # w, h = d.textsize(msg, font = fnt)

    # draw letter on background
    d.text(((W-w)/2, ((H-h)/2)-yshift), msg, font=fnt, fill=font_colour)

    return img


im1 = create_icon('black', 'white', sz, msg, fontstyle, fontsize, yshift)
im2 = create_icon('white', 'black', sz, msg, fontstyle, fontsize, yshift)
im1.save('/Users/jakeireland/projects/jakewilliami.github.io/_assets/images/apple-touch-icon-dark.png')
im2.save('/Users/jakeireland/projects/jakewilliami.github.io/_assets/images/apple-touch-icon-light.png')

# invert image
# inverted_img = PIL.ImageOps.invert(img)
# inverted_img.save('/Users/jakeireland/projects/jakewilliami.github.io/icon_white.png')

def make_circle(img, sz):
    H, W = sz
    img = img.convert('RGB') # RGBA
    np_img = np.array(img)
    h,w = img.size

    # Create same size alpha layer with circle
    alpha = Image.new('L', img.size, 0)
    draw = ImageDraw.Draw(alpha)
    draw.pieslice([0, 0, h, w],0, 360, fill = 255)

    # Convert alpha Image to numpy array
    np_alpha = np.array(alpha)

    # Add alpha layer to RGB
    np_img = np.dstack((np_img, np_alpha))
        
    return Image.fromarray(np_img)


# Save with alpha
im3 = make_circle(im1, sz)
im4 = make_circle(im2, sz)
im3.save('/Users/jakeireland/projects/jakewilliami.github.io/_assets/images/favicon-dark.ico')
im4.save('/Users/jakeireland/projects/jakewilliami.github.io/_assets/images/favicon-light.ico')
