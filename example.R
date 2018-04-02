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
targetQBit <- 1023
quaSys <- init_system(nQubits = 14)
# Grover's search
numIterations <- 100
# Data sctructures to save probabilities (only for visualization purposes)
probabilities <- matrix(ncol = 3, nrow = numIterations)
colnames(probabilities) <- c("iteration", "target", "another")
for (i in seq(numIterations)){
  # Set target through oracle function
  applyOracleFunction(quaSys, target = targetQBit)
  # Apply hadamard
  applyHadamard(quaSys)
  # Apply difusion
  applyDifussion(quaSys)
  # Apply hadamard
  applyHadamard(quaSys)
  # Save probabilities for plot 
  probabilities[i, "iteration"] <- i
  probabilities[i, "target"] <- quaSys@qbitVector[targetQBit+1]
  probabilities[i, "another"] <- quaSys@qbitVector[targetQBit+2]
}
# Plot results
df <- melt(data.frame(probabilities), id.vars = c("iteration"))
ggplot(aes(x=iteration,y=value),data=subset(df, variable == "target")) +
  geom_line(aes(group = variable)) +
  theme_base() +
  ylab("Probability")

assertthat::assert_that(meassurement(quaSys)==1022)

