using JuMP, Cbc

m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))

#=250 candidates participated in an election and 5000 voters cast their votes. If the candidates with the same number of votes
 are grouped in the same group, what is the minimum number of candidates that will be in the largest of these groups?=#


canNum = 250 												# Number of candidates is 250.
voteNum = 5000 												# Number of voters are 5000.
@variable(m, 0 <= counter[1:(voteNum+1)] <= canNum, Int)	# counter[i] denotes the number of candidates who get i-1 number of votes. 
@variable(m, maxCan >= 0, Int)								# Number of members in the largest group.
@constraint(m, sum(counter) == canNum)		 				# Summation of group sizes must add up to 250. In other words each candidate should have an vote count.
@constraint(m, counter'*collect(0:voteNum) == voteNum) 		# When we multiply each value in counter with its (index-1) and sum them up, we should get the value 5000 
															# which is the number of voters.
@constraint(m, flow[i in 1:5001], maxCan >= counter[i])		# Number of members in the largest group should >= to any other group size since it is the largest group.
@objective(m, Min, maxCan)									# Minimize the size of the largest group.
optimize!(m)												# Find optimal solution for the model
#This function prints each group if it has at least 1 member.
function x()
	for i = 1:voteNum+1
		if(value(counter[i]) != 0)
			println("Number of candidates with ", i-1, " votes: ", round(value(counter[i])))
		end
	end
end
println("Number of candidates in the election: ", canNum)
println("Number of voters that cast their votes: ", voteNum)
println("Optimal answer to the question is: ", objective_value(m))
#Following line could be commented out to see size of each group that have at least 1 member.
#x()