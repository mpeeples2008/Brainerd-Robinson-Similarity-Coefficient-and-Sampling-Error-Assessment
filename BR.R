# script by Matt Peeples, Matthew.Peeples@asu.edu, http://www.public.asu.edu/~mpeeple/

library(statnet) # initialize necessary library

# Function for calculating Brainerd-Robinson (BR) coefficients
BR <- function(x) {
rd <- dim(x)[1]
results <- matrix(0,rd,rd)
for (s1 in 1:rd) {
for (s2 in 1:rd) {
x1Temp <- as.numeric(x[s1, ])
x2Temp <- as.numeric(x[s2, ])
br.temp <- 0
results[s1,s2] <- 200 - (sum(abs(x1Temp - x2Temp)))}}
row.names(results) <- row.names(x)
colnames(results) <- row.names(x)
return(results)}

# Obtain input table 
br.tab1 <- read.table(file='BR.csv', sep=',', header=T, row.names=1) # the name of each row (site name) should be the first column in the input table
br.tab1 <- na.omit(br.tab1)

# Ask for user if data are counts or percents
choose.per <- function(){readline("Are the type data percents or counts? 1=percents, 2=counts : ")} 
per <- as.integer(choose.per())

# If user selects counts, convert data to percents and run simulation
if (per == 2) {
br.tab <- prop.table(as.matrix(br.tab1),1)*100
br.dat <- BR(br.tab) # actual BR values

# Calculate the proportions of each category in the original data table
c.sum <- matrix(0,1,ncol(br.tab1))
for (i in 1:ncol(br.tab1)) {
c.temp <- sum(br.tab1[,i])
c.sum[,i] <- c.temp}
p.grp <- prop.table(c.sum)

# Create random sample of a specified sample size
MC <- function(x,s.size) {
v3 <- matrix(0,ncol(x),1)
rand.tab.2 <- matrix(0,ncol(x),1)
v <- sample(ncol(x),s.size,prob=p.grp,replace=T)
v2 <- as.matrix(table(v))
for (j in 1:nrow(v2)) {
v3.temp <- v2[j,]
v3[j,1] <- v3.temp}
rand.tab <- as.matrix(prop.table(v3))*100
rand.tab.2[,1] <- rand.tab
return(rand.tab.2)}

r.sums <- as.matrix(rowSums(br.tab1)) # Calculate sample size by row

# Initate random samples for all rows
BR_rand <- function(x) {
rand.test <- matrix(0,ncol(x),nrow(r.sums))
for (i in 1:nrow(x)) {
rand.test[,i] <- MC(br.tab1,r.sums[i,])}
return(rand.test)}

br.diff.out <- matrix(0,nrow(br.dat),ncol(br.dat)) # Initialize table

# Ask for user how many random counts to calculate
choose.per <- function(){readline("How many random runs (1000 = recommended): ")} 
randruns <- as.integer(choose.per())

# Run MC simulation of BR values
for (i in 1:randruns) {
br.temp <- BR_rand(br.tab1)
br.temp <- t(br.temp)
br.test <- BR(br.temp)
br.diff <- br.dat - br.test
br.diff2 <- event2dichot(br.diff,method='absolute',thresh=0)
br.diff.out <- br.diff.out + br.diff2}

br.diff.out <- br.diff.out / randruns # Calculate probabilities based on random runs
row.names(br.diff.out) <- row.names(br.tab1)
colnames(br.diff.out) <- row.names(br.tab1)

write.table(br.diff.out,file='BR_prob.csv',sep=',') # Write output

} # close if statement for count data

# Recalculate actual BR values and output to file
br.tab <- prop.table(as.matrix(br.tab1),1)*100
br.dat <- BR(br.tab)
write.table(br.dat,file='BR_out.csv',sep=',') # Write output

# end of script