import numpy as np
import pylab as pl

f = lambda x: 2*x**3 - x**2 - 4*x + 2
df = lambda x: 6*x**2 - 2*x - 4
#H = lambda x: np.array([[12*(x[0]-2)**2+2, -4],[-4,8]])
# start = np.array([0,3])
start = 6
xstar = 1
# xstar = np.array([2,1])

#f = lambda x: x[0]**2 + 4*x[1]**2 - 4*x[0] - 8*x[1]
#df = lambda x: -p.array([2*x[0]-4,8*x[1]-8])
#start = np.array([0,0])
#xstar = np.array([0,0])

#f = lambda x: (x[0]-3)**2 + (x[1]-2)**2
#df = lambda x: np.array([2*(x[0]-3),2*(x[1]-2)])
#start = np.array([1,1])
#xstar = np.array([3,2])

def linesearch(x,fprime,alpha0=0.25,rho=0.5,c=0.5):
	alpha = alpha0
	#print(f(x-alpha*fprime) , f(x) - c*alpha*fprime**2)
	while f(x-alpha*fprime) > f(x) - c*alpha*np.dot(fprime,fprime):
		alpha = rho*alpha
	print alpha
	return alpha
	
def gradientDescent(x0,eps=1e-5):
	previousStepSize = 1.0
	x = x0
	nsteps = 0
	pl.plot(x[0],x[1],'ko',ms=20)
	while previousStepSize>eps and nsteps<50:
		oldx = x
		stepsize = linesearch(x,df(oldx))
		x = x - stepsize*df(oldx)
		print df(oldx), x
		previousStepSize = np.linalg.norm(x - oldx)
		pl.quiver(oldx[0],oldx[1],x[0]-oldx[0],x[1]-oldx[1],scale_units='xy',angles='xy',scale=1)
		pl.plot([oldx[0],x[0]],[oldx[1],x[1]],'ro')
		nsteps += 1
	print("Local minimum at ", x, " with value ",f(x)," after ",nsteps," steps")
	return x

X = np.arange(0, 4, 0.1)
Y = np.arange(0, 3, 0.1)
X, Y = np.meshgrid(X, Y)
Z = (X-2)**4 + (X-2.0*Y)**2
#Z = (X-3)**2 + (Y-2)**2

pl.figure()
pl.contour(X,Y,Z,10)

pl.plot(start,'ko',ms=20)
x = gradientDescent(start)
pl.plot(xstar,'go',ms=20)
pl.title("Line Search")
pl.show()
