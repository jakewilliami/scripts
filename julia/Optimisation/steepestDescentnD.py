import numpy as np
import pylab as pl
import plot3d

f = lambda x: (x[0]-3)**2 + (x[1]-2)**2
df = lambda x: np.array([2*(x[0]-3),2*(x[1]-2)])
start = np.array([1,1])
xstar = np.array([3,2])

#f = lambda x: (x[0]-2)**4 + (x[0]-2*x[1])**2
#df = lambda x: np.array([4*(x[0]-2)**3 + 2*(x[0]-2*x[1]),-4*(x[0]-2*x[1])])
#H = lambda x: np.array([[12*(x[0]-2)**2+2, -4],[-4,8]])
#start = np.array([0,3])
#xstar = np.array([2,1])

#f = lambda x: x[0]**2 + 4*x[1]**2 - 4*x[0] - 8*x[1]
#df = lambda x: np.array([2*x[0]-4,8*x[1]-8])
#H = lambda x: np.array([[12*(x[0]-2)**2+2, -4],[-4,8]])
#start = np.array([0,0])
#xstar = np.array([2,1])

def steepestDescent(x0,eps=1e-5,stepsize=0.1):
	previousStep = 1.0
	x = x0
	nsteps = 0
	print(f(x))
	while previousStep>eps:
		print(x)
		oldx = x
		x = x - stepsize*df(oldx)
		previousStep = np.linalg.norm(x - oldx)
		nsteps += 1
		#print df(oldx), x, f(x)
		pl.quiver(oldx[0],oldx[1],x[0]-oldx[0],x[1]-oldx[1],scale_units='xy',angles='xy',scale=1)
		pl.plot([oldx[0],x[0]],[oldx[1],x[1]],'ro')
	print("Local minimum at ", x, " with value ",f(x)," after ",nsteps," steps")
	return x

X = np.arange(0, 4, 0.1)
Y = np.arange(0, 3, 0.1)
X, Y = np.meshgrid(X, Y)
Z = (X-2)**4 + (X-2*Y)**2
#Z = (X-3)**2 + (Y-2)**2
plot3d.plot3d(X,Y,Z)

fig = pl.figure()
pl.contour(X,Y,Z,10)
pl.plot(start[0],start[1],'ko',ms=20)
x = steepestDescent(start)
pl.plot(xstar[0],xstar[1],'go',ms=20)
pl.title("Steepest Descent")
pl.show()
