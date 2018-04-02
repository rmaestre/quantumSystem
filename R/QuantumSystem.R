setClass (
  # Class name
  "QuantumSystem",

  # Defining slot type
  representation (
    qbitVector = "numeric",
    hadamardGate= "numeric"
  ),

  # Initializing slots
  prototype = list(
    qbitVector = NULL,
    hadamardGate = NULL)
)
