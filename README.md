# Big-Data-Analysis-Analysing-Clinical-trial-Data

Skills assessed 
• The usage of common big data tools and techniques
• Your ability to implement a standard data analysis process
– Loading the data
– Cleansing the data
– Analysis
– Visualisation / Reporting
• Use of Python, SQL and Linux terminal commands


we
are tasked with answering these questions, using visualisations where these would support our conclusions.
we addressed the following problem statements. 
1. The number of studies in the dataset. 
2. List all the types (as contained in the Type column) of studies in the dataset along with
the frequencies of each type. These should be ordered from most frequent to least frequent.
3. The top 5 conditions (from Conditions) with their frequencies.
4. Each condition can be mapped to one or more hierarchy codes. The client wishes to know the 5
most frequent roots (i.e. the sequence of letters and numbers before the first full stop) after this is
done.
To clarify, suppose your clinical trial data was:
NCT01, ... ,"Disease_A,Disease_B",
NCT02, ... ,Disease_B,
And the mesh file contained:
Disease_A A01.01 C23.02
Disease_B B01.34.56
The result would be
B01 2
A01 1
C23 1
5. Find the 10 most common sponsors that are not pharmaceutical companies, along with the number
of clinical trials they have sponsored. Hint: For a basic implementation, you can assume that the
Parent Company column contains all possible pharmaceutical companies.
6. Plot number of completed studies each month in a given year – for the submission dataset, the year
is 2021. You need to include your visualization as well as a table of all the values you have plotted
for each month.
