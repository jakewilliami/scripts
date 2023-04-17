import math

import turtle


def turtle_set_up(colour: str) -> turtle.Turtle:
    t = turtle.Turtle()
    t.shape("turtle")
    t.color(colour)
    return t


def calc_side_len(n: int, w: int):
    """
    Calculate the length of each side of a regular polygon with `n` sides of width `w`.
    """
    # https://math.stackexchange.com/a/4680901/705172
    return w * math.sin(math.radians(360 / (2 * n)))


def draw_shape(t: turtle.Turtle, n: int, w: int):
    """
    Draw a shape with `n` sides of width `w` using turtle `t`.
    """
    side_length = calc_side_len(n, w)
    for _ in range(n):
        t.forward(side_length)
        t.right(360 / n)


def main() -> int:
    # Set up screen
    wn = turtle.Screen()
    wn.bgcolor("lightblue")

    # Turtle set up
    tess = turtle_set_up("blue")
    alex = turtle_set_up("green")
    bex = turtle_set_up("hotpink")
    clive = turtle_set_up("orange")

    # Turtles move out from centre
    # They should always face to the right at the end of their move
    for t, r in ((tess, 0), (alex, 180), (bex, 90), (clive, 270)):
        t.penup()
        t.right(r)
        t.forward(100)
        t.left(r)
        t.pendown()

    # Draw shapes
    shape_width = 30
    draw_shape(tess, 3, shape_width)  # triangle
    draw_shape(alex, 4, shape_width)  # square
    draw_shape(bex, 6, shape_width)  # hexagon
    draw_shape(clive, 8, shape_width)  # octagon

    wn.mainloop()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
