/********************************************************************************************/
/* Program Name:     pulkit.jain_HW16.sas												    */
/* Program Location: C:\Users\Pulkit Jain\Documents\sasuniversityedition\myfolders\assign16 */
/* Date Created:     12/04/2017      													    */
/* Author: 			 Pulkit Jain          										            */
/* Purpose:  		 Assignment 16, Read from Raw Datafile								    */
/********************************************************************************************/

/* 1 Use a fileref to access dat file, include headers*/
/* Create two libname statements; 						  */
/* Assign library to locaion of hw data with access only; */
/* Assign another library with read and write access;     */


filename andro '/folders/myfolders/hw_data/andromeda.dat';

libname hw_data '/folders/myfolders/hw_data' access=readonly;
libname pulkit16 '/folders/myfolders/assign16';

/* Specify a fileref to designate output of pdf */

filename HW16 '/folders/myfolders/assign16/pulkit.jain_HW16_output.pdf';

/* 2 Read and create datasest with 4 variables, Level, Name, Designation & Salary*/

/* Specify options for output pdf file */
ods pdf file = HW16 bookmarkgen=yes;
options dtreset;

data work.andro_data (Keep= Level Employee_Name Job_Title Salary);
	length Level 3 Employee_Name $25 Job_Title $25; 
	infile andro truncover;
	* read in levels and check what category they belong to;
	input @1 row_st1 $8. 
		  @10 row_st2 $8.
		  @19 row_st3 $8.
		  @28 row_st4 $8.
		  @37 row_st5 $8.
		  @46 row_st6 $8.
		  @;
	if row_st1 = '(Level1)' then do;
		Level = 1;
		input @10 employee_info $50. @;
	end;
	else if row_st2 = '(Level2)' then do;
		Level = 2;
		input @19 employee_info $50. @;
	end;
    else if row_st3 = '(Level3)' then do;
		Level = 3;
		input @28 employee_info $50. @;
	end;
	else if row_st4 = '(Level4)' then do;
		Level = 4;
		input @37 employee_info $50. @;
	end;	
  	else if row_st5 = '(Level5)' then do;
		Level = 5;
		input @46 employee_info $50. @;
	end;
	else do;
		Level = 6;
		input @54 employee_info $50. @;
	end;	
	input @106 Salary dollar10.0 @;
	* parse job title & employee name from the employee info variable;
	Job_Title = substr(employee_info, 1, find(employee_info,'(') - 1);
	Employee_Name = substr(employee_info, find(employee_info,'(') + 1);
	Employee_Name = compress(Employee_Name, ')');
run;	
	

/* 3 Use Frequency Procedure on Job_Title */

PROC FREQ data = andro_data;
	tables Job_Title;
	title1 "Analysis of Andromeda Employee Data for Clean Up";
	title3 "Frequency Report of Job Title";
run;

/* 4 Use Univariate Procedure on Salary variable */

PROC univariate data = andro_data;
	var Salary;
	title1 "Analysis of Andromeda Employee Data for Clean Up";
	title2 "Analysis of Salary Values";
run;

/* 5 Print irregular salaries data */

PROC PRINT data = andro_data ;
	where  24000 > Salary  or Salary > 433800;
	title2 "Salary Values to be Investigated";
RUN;

/* 6 Clean Up the job titles conditionally */

data work.andro_clean;
    set work.andro_data;
    if Job_Title='Accountant i' 
    	then Job_Title='Accountant I';
    else if Job_Title='Accountant ii' 
    	then Job_Title='Accountant II';
    else if Job_Title='Accountant iii' 
    	then Job_Title='Accountant III';
    else if Job_Title='Warehouse Assistant i' 
    	then Job_Title='Warehouse Assistant I';
    else if Job_Title='Warehouse Assistant ii' 
    	then Job_Title='Warehouse Assistant II';
run;

/* 7 Use Freq procedure to show job titles in cleaned data*/

proc freq data = work.andro_clean nlevels;
	table Job_Title / noprint;
	title1 "Number of Different Jobs in Cleaned Data";
run;

/* 8 Print Employees with titles Chief, Director, or Temp. or Vice President*/

/* Sort Data By Job level */
proc sort data = work.andro_clean;
	by Level;
RUN;

title "List of Andromeda Employees to be Reviewed for Orion Positions";

/* Print required observations */
proc print data=work.andro_clean;
  id Level;
  by Level;
  var Job_Title Employee_Name;
  where Job_Title like '%Chief%' 	or 
  		Job_Title like '%Director%' or 
  		Job_Title like '%Temp.%' 	or 
  		Job_Title like '%Vice President%';
run;

/* 9 Houskeeping to make sure title or footnote dont carry over */

title;
footnote;

/* 10 Close PDF Output */
ods pdf close;
ods listing;
	