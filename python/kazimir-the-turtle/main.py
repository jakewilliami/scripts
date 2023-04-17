import math

from turtle import Turtle, Screen


def turtle_set_up(colour: str) -> Turtle:
    t = Turtle()
    t.shape("turtle")
    t.color(colour)
    return t


def calc_side_len(n: int, w: int):
    """
    Calculate the length of each side of a regular polygon with `n` sides of width `w`.
    """
    # https://math.stackexchange.com/a/4680901/705172
    return w * math.sin(math.radians(360 / (2 * n)))


def move_outwards(t: Turtle, r: int = 0, f: int = 100):
    """
    Rotate turtle `t` `r` degrees clockwise, move forward `f` units, and rotate back to the original position.
    """
    t.penup()
    t.right(r)
    t.forward(f)
    t.left(r)
    t.pendown()


def draw_shape(t: Turtle, n: int, w: int = 30):
    """
    Draw a shape with `n` sides of width `w` using turtle `t`.
    """
    side_length = calc_side_len(n, w)
    for _ in range(n):
        t.forward(side_length)
        t.right(360 / n)


def main() -> int:
    # Set up screen
    wn = Screen()
    wn.bgcolor("lightblue")

    # Turtle set up
    tess = turtle_set_up("blue")
    alex = turtle_set_up("green")
    bex = turtle_set_up("hotpink")
    clive = turtle_set_up("orange")

    # Turtles move out from centre
    # They should always face to the right at the end of their move
    move_outwards(tess)
    move_outwards(alex, 180)
    move_outwards(bex, 90)
    move_outwards(clive, 270)

    # Draw shapes
    draw_shape(tess, 3)  # triangle
    draw_shape(alex, 4)  # square
    draw_shape(bex, 6)  # hexagon
    draw_shape(clive, 8)  # octagon

    wn.mainloop()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
