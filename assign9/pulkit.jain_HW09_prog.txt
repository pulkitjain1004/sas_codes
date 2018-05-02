* 1 Open the program HW09.sas;
* 2 Save it as a different name (pulkit.jain_HW09.sas);

* 3 Add the header section;

/***********************************************************************/
/* Program Name:     pulkit.jain_HW09.sas												   */
/* Program Location: C:\Users\Pulkit Jain\Documents\sasuniversityedition\myfolders\assign9 */
/* Date Created:     10/09/2017      													   */
/* Author: 			 Pulkit Jain          										           */
/* Purpose:  		 Assignment 9, practice with accessing sas data, and view content  	   */

* 4 Create two libname statements;
* Assign library called orion to locaion of data with access only;
* Assign another library with read and write access;

libname orion '/folders/myfolders/prog1' access=readonly;
libname pulkit09 '/folders/myfolders/assign9';

* 5 Run the code inside HW09.sas;
/* data work.donations; */
/*    set orion.Employee_donations; */
/*    keep Employee_ID Qtr1 Qtr2 Qtr3 Qtr4; */
/*    Total=sum(Qtr1,Qtr2,Qtr3,Qtr4); */
/* run; */

* 6 Comment out proc statement;
* proc print data=work.donations;

* 7 Edit the data step above so that it creates it in new library;

/* data pulkit09.donations; */
/*    set orion.Employee_donations; */
/*    keep Employee_ID Qtr1 Qtr2 Qtr3 Qtr4; */
/*    Total=sum(Qtr1,Qtr2,Qtr3,Qtr4); */
/* run; */

* 8 Open a pdf output to capture the following results;
/* ods pdf file = '/folders/myfolders/assign9/pulkit.jain_HW09_outputA.pdf' bookmarkgen= no; */
ods pdf file = '/folders/myfolders/assign9/pulkit.jain_HW09_outputB.pdf' 
bookmarkgen= no style=sasweb;


* 9 Add a proc contents step that will display the descriptor portion of the donations data set;
* Add a title to it;
title 'Descriptor Portion of Donations Permanent Data Set';
PROC CONTENTS data = pulkit09.donations;
RUN;

* 10 Add a proc statement to show content of work library. With descriptor portion of each data;
title 'Descriptor Portion of All Data Sets in Work Library';
PROC CONTENTS data = work._ALL_ ;
RUN;

* 11 Add a proc statement to show content of work library. Without descriptor portion of each data;

title 'List of Data Sets in Orion Library';
PROC CONTENTS data = orion._ALL_ NODS;
RUN;

* 12 close pdf output destination;
ods pdf close;

ods listing;

/* 13 Signout and run the program */
/* 14 Comment out step 5 & 7, and pdf output statement */
/* Create a new similar pdf, titled outputB, with different color */
/* 15 Execute the program */