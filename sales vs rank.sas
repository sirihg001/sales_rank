/* Step 0: Start the PDF output */
ODS PDF FILE='/home/output.pdf';

/* Step 1: Import the dataset */
FILENAME REFFILE '/home/Restaurant Ranking.xlsx';

PROC IMPORT DATAFILE=REFFILE
    DBMS=XLSX
    OUT=resdata
    REPLACE;
    GETNAMES=YES;
RUN;

/* Step 2: Check the dataset structure */
PROC CONTENTS DATA=resdata;
RUN;

/* Step 3: Create Training and Testing Sets */
PROC SURVEYSELECT DATA=resdata OUT=resttrain METHOD=SRS SAMPRATE=0.7 SEED=123;
RUN;

PROC SORT DATA=resttrain; 
    BY Rank;
RUN;

/* Step 4: Fit a Decision Tree model */
PROC HPSPLIT DATA=resttrain;
    MODEL Sales = Rank;
RUN;

/* Step 5: Close the PDF output */
ODS PDF CLOSE;
