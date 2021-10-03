using LinearAlgebra: norm

using Plots
plotly()

f(x) = (x[1] - 3)^2 + (x[2] - 2)^2
df(x) = [2*(x[1] - 3), 2*(x[2] - 2)]
start = [1, 1]
x⋆ = [3, 2]

function steepest_descent(x₀, ε = 1e-5, stepsize = 0.1)
	previous_step = 1.0
	x = x₀
	nsteps = 0
	while previous_step > ε
		oldx = x
		x = x - stepsize*df(oldx)
		previous_step = norm(x - oldx)
		nsteps += 1
		# println(df(oldx), " ", x, " ", f(x))
		plt = quiver(oldx[1], oldx[2], quiver=(x[1] - oldx[1], x[2] - oldx[2]))
		plot!(plt, [oldx[1], x[1]], [oldx[1], x[1]])
	end
	println("Local minimum at ", x, " with value ", f(x), " after ", nsteps, " steps")
	return x
end
