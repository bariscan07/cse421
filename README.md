## **CSE 421 Optimization Theory and Techniques Project 1 Submission**

  Includes julia codes to optimize SailCo problem and its 3 different variations.
  ### SailCo Variation 1: Better handling of the Rolling Horizon
  - Original solution of SailCo problem (**sailco.jl**) leaves the company with the zero boats on hand at the end of 4th quarter.
  - Solution to this variation (**sailcovar1.jl**) guarantees that company will end with 10 boats in inventory.
  - There is also a difference between forecast demand (40) and actual demand (35) which leads to beginning of 2nd quarter with 15 boats.
  - Solution for this variation solves LP for Q2—Q5 and starting with 15 boats.
  - Demand for 5th quarter is 36.
  ### SailCo Variation 2: Production-smoothing costs
  - In this variation change in production across periods matters since it will affect the production cost.
  - Increase in production: $400/boat (training)
  - Decrease in production: $500/boat (severance pay,decreasing morale, etc.).
  - We assume 50 both on company's hand before 1st quarter.
  - **sailcovar2.jl** provides a optimal solution for this variation.
  - Notice, we cannot have both positive values for positive and negative change since it is impossible.
  ### SailCo Variation 3: Allowing demands to be backlogged
  - For this case, demands might unmet for any quarter which results in $100 penalty.
  - **sailcovar3.jl** modifies the solution so that variables offers potential backlog and includes penalty in objective function.
