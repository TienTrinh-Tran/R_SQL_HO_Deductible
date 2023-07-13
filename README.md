# R/SQL Home Deductible
This was an ad-hoc project aimed at analyzing the trends in Home Deductibles over the past 10 years.

The SQL script retrieves data for each of the past 10 years and combines them into a single table on the server. The R script is then used to analyze the results. The script generates graphs and figures, which are subsequently outputted to an Excel workbook for reporting to management.

There might be repetitive code to create graphs. This approach was intentional for the following reasons:
- The analysis needed to be completed quickly, and this project may be a one-time analysis only.
- There are variations among the categories, so having the flexibility to modify the code to create visually appealing graphs was considered advantageous for the output.
