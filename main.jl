# This file "main" must be run to call function
# ospatsmr() or allocatemr(), after filling in the name
# of the data file and the process parameters below.
# Data file: no header, comma-separated values, x, y, prediction
# and prediction error variance in column 1, 2, 4 and 5.

# Version: 2017-10-28
# Author: Jaap de Gruijter

include("./ospatsmr.jl")
include("./allocatemr.jl")

using CSV
using DataFrames
using Random

filename = "Nowley.txt"     #### INSERT here name of data file
println("File name :  ", filename)

################################ INSERT here process parameters:
R2 = 0.36       # squared correlation coefficient of predictions.
range = 582     # auto-correlation range of the prediction error,
# in the same length unit as x and y.
maxcycle = 100  # Maximal number of re-allocation cycles.
H = 5           # Number of strata.
runmax = 2      # Number of runs.
in = 1          # Sampling interval for coarse-gridding
# (in = 1 implies no coarse-gridding).
nmax = 50       # Sample size for which the Relative Standard Error,
# as percentage of the grid average of the,
# predictions is calculated.
RSEmax = 1.5    # Relative Standard Error for which the sample size
# is calculated.
seed = 1234     # seed for the rand() and randperm() functions.
rng = Random.seed!(seed)

##################################### Reading the data file
# Data = CSV.read(filename, header=false, separator=',')
Data = CSV.read(filename, DataFrame)
x = Data[!, :1]
y = Data[!, :2]
# nr = Data[:3]        grid point identifier
z_pred = Data[!, :4]
s2 = Data[!, :5]
N = length(x)
println("Grid size : ", N)

##################################### Checking process parameters
if H < 1                                    # check H
  println("ERROR: H is smaller than 1")
  quit()
end
type_H = typeof(H)
if type_H != Int64
  print("ERROR: H is not an integer")
  quit()
end

if runmax < 1                                # check runmax
  println("ERROR: runmax is smaller than 1")
  quit()
end
type_runmax = typeof(runmax)
if type_runmax != Int64
  print("ERROR: runmax is not an integer")
  quit()
end

if maxcycle < 0                              # check maxcycle
  println("ERROR: maxcycle is negative")
  quit()
end
type_maxcycle = typeof(maxcycle)
if type_maxcycle != Int64
  print("ERROR: maxcycle is not an integer")
  quit()
end

if in < 1                                    # check in
  println("ERROR: in is smaller than 1")
  quit()
end
type_in = typeof(in)
if type_in != Int64
  print("ERROR: in is not an integer")
  quit()
end

if nmax < H                                  # check nmax
  println("ERROR: nmax is smaller than H")
  quit()
end
type_nmax = typeof(nmax)
if type_nmax != Int64
  print("ERROR: nmax is not an integer")
  quit()
end

if R2 < 0                                    # check R2
  println("ERROR: R2 is negative")
  quit()
end
if R2 > 1
  println("ERROR: R2 is larger than 1")
  quit()
end

if range <= 0                                 # check range
  println("ERROR: range is zero or negative")
  quit()
end

if RSEmax <= 0                                # check RSEmax
  println("ERROR: RSEmax is zero or negative")
  quit()
end
if RSEmax > 100
  println("ERROR: RSEmax is larger than 100")
  quit()
end

println("Seed for random number generator : ", seed)
println("Number of strata :  ", H)
println("Sampling interval :  ", in)
println("R2 :  ", R2)
println("Range :  ", range)
println("Maximum number of iteration cycles :  ", maxcycle)
println("Number of runs :  ", runmax)
println("Sample size for which the RSE is calculated :  ", nmax)
println("RSE for which the sample size is calculated :  ", RSEmax)

if in == 1
  println("Calling function ospatsmr")
  ospatsmr()
elseif in > 1
  println("Calling function allocatemr")
  allocatemr()
end     # if in == 1
