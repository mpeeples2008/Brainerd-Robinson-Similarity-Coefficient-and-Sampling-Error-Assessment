# Brainerd-Robinson-Similarity-Coefficient-and-Sampling-Error-Assessment
Script for calculating Brainerd-Robinson coefficients based on tabular count or percent data. This script also estimates the probability that a given difference between two samples is the product of sampling error.

Brainerd Robinson Coefficient of Similarity:
The Brainerd-Robinson (BR) coefficient is a similarity measure that was developed within archaeology specifically for comparing assemblages in terms of the proportions of types or other categorical data. Although this measure is commonly used in archaeological studies, it cannot be calculated with most commercial software packages. This script calculates BR coefficients on count or percent data. Further, following procedures first described by DeBoer, Kintigh, and Rostoker (1996), this script also calculates the probabilities of obtaining a BR similarity value less than or equal the actual value by chance for every pair-wise comparison. These probability values can be useful in determing when differences between sites might be a function of sampling error and when they are likely not. This probability assessment is described in more detail below.

BR is a city-block metric of similarity (S) that is calculated as:

S=200-(Sum(|Pik=Pjk|))

where, for all variables (k), P is the total percentage in assemblages i and j. This provides a scale of similarity from 0-200 where 200 is perfect similarity and 0 is no similarity. 

This remainder of this document provides a brief overview of the BR.R script. This script is based on the BRSAMPLE originally written by Keith Kintigh as part of the Tools for Quantitative Archaeology program suite. You can download a sample data file along with the script to follow along with this example. Right click and click Save As for both of the files above. The sample data used here are based on Huntley's (2004, 2008) ceramic compositional study focused on the Zuni region. The discussion and interpretations of the sample data presented below are also based on Huntley's published work.

File Format:
This script is designed to use the *.csv (comma separated value) file format. 

Table Format:
Tables should be formatted with each of the samples/sites/observations as rows and each of the categorical variables as columns. The first row of the spreadsheet should be a header that labels each of the columns. The first column should contain the name of each unit (i.e., level, unit, site, etc.). Row names may not be repeated. All of the remaining columns should contain numerical count or percent data. The sample data from Huntley's (2004, 2008) study consist of counts of 5 ceramic compositional groups from 9 sites in the Zuni region :

Requirements for Running the Script:
In order to run this script, you must install the R statistical platform (version 2.8 or later) and the "statnet" package.

Starting the Script:
The first step for running the script is to place the script file "BR.R" and the data file "BR.csv" in the working directory of R. To change the working directory, click on "File" in the R window and select "Change dir", then simply browse to the directory that you would like to use as the working directory. Next, to actually run the script, type the following line into the R command line:

source('BR.R')

Running the Script:
After typing the command above into the command line, the console will request user input with two prompts. 

1) Are the data percents or counts? 1=percents, 2=counts:
At this prompt enter 1 if input data are percents. For percent data, the script will output a rectangular matrix of BR values for all pair-wise comparisons and then end without running the sampling error assessment (which requires count data). If the data are counts, a second prompt will appear.

2) How many random runs :
At this prompt, enter the number of random runs that you wish use to assess sampling error. Increasing the number of random runs increases the total time it will take to calculate probabilities. Most relatively recent computers (should be able to calculate 1,000 runs in a few seconds to several minutes depending on the size of the original data table.

Output:
After the script has run, one or two files will be placed in the R working directory depending on whether percent or count data were input.

For both percent and count data, a file named "BR_out.csv" will be output. This file is a rectangular matrix of Brainerd-Robinson similarity coefficients for all sites/samples included. If the input data are counts, a second file named "BR_prob" will also be created. This file is a rectangular matrix of probability values based on the Monte Carlo simulation procedure described below. In this table, a value of 0 indicates a probability less than the number of significant digits considered. For example, if probabilities were calculated to thousandths (i.e., 0.115), a value of 0 indicates some value < 0.001. The sample output table should be similar to the table shown below. Actual values will vary somewhat do to the randomization procedure. The sample output shown here was calculated based on 1,000 random runs. Again, numbers shown in red in the table below represent comparisons between sites in the same settlement cluster and comparisons in black represent comparisons between settlement clusters.

Interpreting the Output:

The BR values provided in the first table above are relatively easy to interpret. A higher value indicates that the assemblages being compared are more similar in terms of the proportions of categorical variables considered (in this case, ceramic compositional groups). A cursory inspection of the BR matrix for the sample data suggests that BR values are highest among settlements in the same cluster (Huntley 2004, 2008). 

Because the sizes of the samples considered in a similarity matrix can often vary considerably, however, it is also important to assess the possibility that the differences among samples are the result of sampling error. For this script, I follow the procedures described by DeBoer and others (1996). This script estimates the probability of obtaining a BR value as low as or lower than a given comparison by chance using a Monte Carlo simulation procedure. Specifically, 1,000 random samples of a specified sample size (based on the actual number of samples in each two-way comparison) are drawn with replacement from a population with proportions defined by the actual number of samples in each category for all samples. 

For example, with the sample data if we were to compare the compositional sample from Atsinna (n=29) with the sample from Cienega (n=18), we would draw two random samples (with replacement) from the global pool of all samples from all sites of n=29 and n=18. We would then calculate the BR similarity coefficient between these two random samples. This same procedure would then be repeated until the desired number of random runs has been obtained (in this case 1,000). The proportion of all of the random samples which produce BR values less than or equal to the actual BR value for a comparison between two samples provides an indication of the probability that an observed difference may be due to sampling error. For example, a probability value of p=0.005 means that in only 5 out of 1,000 random runs was a BR value less than or equal to the observed obtained. Such a low probability suggests that the differences between the sites being compared are extremely unlikely to have been the result of sampling error. On the other hand, a value of p=0.250 suggests that approximately 1 in 4 random samples pulled from the global pool produced BR values less than or equal to the observed value. This suggests that any minor differences among samples may be related to the vagaries of sampling. 

For the sample data, comparisons between sites in the same settlement cluster all display relatively high probability values whereas comparisons between sites in different settlement clusters all have quite low probability values. This suggests that the differences between sites in different clusters are not likely the result of sampling error. Conversely, minor differences in similarity values among sites in the same settlement cluster are similar to what might be expected by chance. Thus, minor differences among sites in the same area are likely attributable, at least in part, to sampling error.

It is also be possible to calculate probabilities based on some distribution other than the global pool of all samples (DeBoer et al. 1996). In order to do this, replace the section of the script calling the "p.grp" object with the following:

p.grp <- as.matrix(read.table(file='prob.csv',sep=',',header=T))

Place a tabular *.csv file in the R working directory named "prob.csv" in the following format. The first row should provide variable names and the second row should provide the proportions of each variable to be used in the random sampling procedure. The variables must be exactly the same as in the original data file. Such a procedure might be useful if you wanted to compare the proportional representation of objects away from where they are produced to the proportions in the production area (e.g., Bernardini 2005).

References Cited:

Bernardini, Wesley
2005 Hopi Oral Tradition and the Archaeology of Identity. University of Arizona Press, Tucson.

DeBoer, Warren R., Keith W. Kintigh, and Arthur G. Rostoker
1996 Ceramic Seriation and Site Reoccupation in Lowland South America. Latin American Antiquity, 7(3):263-278.

Huntley, Deborah L.
2004 Interaction, Boundaries, and Identities: A Multiscalar Approach to the Organizational Scale of Pueblo IV Zuni Society. Ph.D. Dissertation, Arizona State University.

Huntley, Deborah L.
2008 Ancestral Zuni Glaze-Decorated Pottery: Viewing Pueblo IV Regional Organization through Ceramic Production and Exchange. Anthropological Papers No. 72. University of Arizona Press, Tucson.
