import math
from subprocess import CalledProcessError, call, check_call

def dy_dx(x, y):
    try:
        # declare your dy/dx here:
        return x**2-x-2
    except ZeroDivisionError:
        return 1000.0

# Adjust window parameters
XMIN = -5.0
XMAX = 5.0
YMIN = -10.0
YMAX = 10.0
XSCL = 0.5
YSCL = 0.5

DISTANCE = 0.1

def main():
    fileobj = open("data.txt", "w")
    for x1 in xrange(int(XMIN / XSCL), int(XMAX / XSCL)):
        for y1 in xrange(int(YMIN / YSCL), int(YMAX / YSCL)):
            x= float(x1 * XSCL)
            y= float(y1 * YSCL)
            slope = dy_dx(x,y)
            dx = math.sqrt( DISTANCE/( 1+math.pow(slope,2) ) )
            dy = slope*dx
            fileobj.write(str(x) + " " + str(y) + " " + str(dx) + " " + str(dy) + "\n")
    fileobj.close()


    try:
        check_call(["gnuplot","-e","set terminal png size 800,600 enhanced font \"Arial,12\"; set xrange [" + str(XMIN) + ":" + str(XMAX) + "]; set yrange [" + str(YMIN) + ":" + str(YMAX) + "]; set output 'output.png'; plot 'data.txt' using 1:2:3:4 with vectors"])
    except (CalledProcessError, OSError):
        print "Error: gnuplot not found on system!"
        exit(1)
    print "Saved image to output.png"
    call(["xdg-open","output.png"])
    return 0

if __name__ == '__main__':
    main()
