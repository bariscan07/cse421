using JuMP, Clp, Printf

d = [40 60 75 25]                   # monthly demand for boats.

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:4] <= 40)       # boats produced with regular labor.
@variable(m, y[1:4] >= 0)             # boats produced with overtime labor.
@variable(m, cpos[1:4] >= 0)		  # denotes positive change in production.
@variable(m, cneg[1:4] >= 0)		  # denotes negative change in production.
@variable(m, hpos[1:5] >= 0)          # boats held in inventory.
@variable(m, hneg[1:5] >= 0)		  # denotes potential backlog.
@constraint(m, hpos[1] == 10)		  # initial inventory of SailCo.
@constraint(m, hpos[5] >= 10)		  # keep inventory of 10 at the end of planning horizon.
@constraint(m, x[1] + y[1] == cpos[1] - cneg[1] + 50)				# assume 50 boats made during the Q preceeding Q1. Thus, leads to this constraint.
@constraint(m, hneg[5] <= 0)		  # must meet all demand by end of Q4.
@constraint(m, flow[i in 1:4], hpos[i] - hneg[i] + x[i]+y[i]==d[i]+hpos[i+1]-hneg[i+1])     # conservation of boats.
@constraint(m, flow2[j in 2:4], x[j] + y[j] - (x[j-1] + y[j-1]) == cpos[j] - cneg[j])		# constraint to capture change in production from period to period.
@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(hpos) + 400*sum(cpos) + 500*sum(cneg) +100*sum(hneg))         # minimize costs.

optimize!(m)						  # find the optimal solution for objective.

@printf("-------------------------------SailCo: Variation 3--------------------------------------\n")
@printf("Boats to build regular labor: %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]))
@printf("Boats to build extra labor: %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]))
@printf("Positive change in production: %d %d %d %d\n", value(cpos[1]), value(cpos[2]), value(cpos[3]), value(cpos[4]))
@printf("Negative change in production: %d %d %d %d\n", value(cneg[1]), value(cneg[2]), value(cneg[3]), value(cneg[4]))
# Notice cpos and cneg values are not both positive since it is not possible to observe positive and negative change at the same time.
@printf("Inventories: %d %d %d %d %d\n", value(hpos[1]), value(hpos[2]), value(hpos[3]), value(hpos[4]), value(hpos[5]))
@printf("Backlog: %d %d %d %d %d\n", value(hneg[1]), value(hneg[2]), value(hneg[3]), value(hneg[4]), value(hneg[5]))
@printf("Objective cost: %f\n", objective_value(m))
@printf("-----------------------------------------------------------------------------------------\n")