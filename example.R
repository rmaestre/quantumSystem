library(quantumSystem)

# Init quantum system
quaSys <- init_system(nQubits = 1)
# Check qbit states
quaSys@qbitVector
# Get one probability
getStateProbability(quaSys, 1)
# Perform a meassurement
meassurement(quaSys)
# Notice the collapse produced
quaSys@qbitVector

# Init quantum system
quaSys <- init_system(nQubits = 2)
# Check qbit states
firstQbits <- quaSys@qbitVector
applyHadamard(quaSys) # Apply Hadamard gate
secondQbits <- quaSys@qbitVector
applyHadamard(quaSys) # Apply Hadamard gate
# Check superpositions
assertthat::assert_that(all(firstQbits != secondQbits))
assertthat::are_equal(firstQbits, quaSys@qbitVector)

# Oracle function
applyOracleFunction(quaSys, target = 3)
assertthat::assert_that(quaSys@qbitVector[4]<0)
# Difussion
quaSys@qbitVector
applyDifussion(quaSys)
assertthat::assert_that(quaSys@qbitVector[1]>0)

# Init quantum system
quaSys <- init_system(nQubits = 13)
# Grover's search
for (i in seq(100)){
  # Set target through oracle function
  applyOracleFunction(quaSys, target = 1022)
  # Apply hadamard
  applyHadamard(quaSys)
  # Apply difusion
  applyDifussion(quaSys)
  # Apply hadamard
  applyHadamard(quaSys)
}
assertthat::assert_that(meassurement(quaSys)==1022)


