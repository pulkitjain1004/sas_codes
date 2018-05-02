/********************************************************************************************/
/* Program Name:     pulkit.jain_HW14.sas												    */
/* Program Location: C:\Users\Pulkit Jain\Documents\sasuniversityedition\myfolders\assign14 */
/* Date Created:     11/20/2017      													    */
/* Author: 			 Pulkit Jain          										            */
/* Purpose:  		 Assignment 14, using arrays & variable lists						    */
/********************************************************************************************/

/* Create two libname statements; 						  */
/* Assign library to locaion of hw data with access only; */
/* Assign another library with read and write access;     */

libname hw_data '/folders/myfolders/hw_data' access=readonly;
libname pulkit14 '/folders/myfolders/assign14';

/* Specify a fileref to designate output of pdf */

filename HW14 '/folders/myfolders/assign14/pulkit.jain_HW14_output.pdf';

/* Pre - steps to prepare the data for merger */

/* Prepare data set receivers */
data Receivers17 (DROP = num);
	set hw_data.Receivers17;
	*define length of variable Team;
	length Team $28;
	*create a variable for extraction of team name from variable Player & remove blank spaces;
	num = find(Player, ',', -length(Player));
	Team = substr(Player, num+2);
	Player = scan(Player, 1, ',');
run;

/* Prepare data set total defense */
data Totaloffense17(Rename= (Rank=TeamRank Games=TeamGames 
							 TDs=TeamTDs   Yds_game=TeamYds_game));
	set hw_data.Totaloffense17(drop=W_L);
run;

*sort Receivers17 dataset by Team;
proc sort data=Receivers17; 
	by Team; 
run;

*sort TotalOffense17 dataset by Team;
proc sort data=Totaloffense17; 
	by Team; 
run;

/* 2 Merge the Receivers17 & TotalOffense17 dataset */

data pulkit14.tot_data team_data norecv (KEEP=TeamRank Team TeamGames Plays YDS
	Yds_Play TeamTDs TeamYds_Game);
	merge Receivers17(in=A) Totaloffense17(in=B);
	by Team;
	length count $8;
	length pct_avgyds 8;
	if A= 1 then count= 'yes';
	else count = 'no';
	pct_avgyds = Yds_Game/TeamYds_Game;
	output pulkit14.tot_data;
	if A=1 & B=1 then output team_data;
	if A=0 then output norecv ;
	label TeamRank= 'Rank' 
		  Plays= 'Total Plays' 
		  YDS= 'Total Yards'
		  Yds_Play= 'Yards per Play' 
		  TeamYds_Game= 'Yards per Game';
	format TeamYds_Game 8.0;	  
run;

/* 3 Create Output */

ods pdf file = HW14 bookmarkgen=yes;
options orientation = landscape nonumber dtreset;

/* 4 sort the data */
proc sort data= norecv; 
	by TeamRank; 
run;


/* 5 Print top 10 observations of data */
proc print data= norecv (obs= 10) label noobs;
	var TeamRank
		Team
		Plays
		YDS
		Yds_Play
		TeamYds_Game;
	title1 "NCAA Football Receiving Analysis";
	title3 "Top 10 Offences with No Top Receivers";
	footnote "Data Downloaded from NCAA.org";
run;

/* 6 Hide date and time*/
options nodate; 
footnote;

/* 7 */

proc freq data=PULKIT14.tot_data;
	tables Cl*Pos/nopercent nocol missing;
	title1 "NCAA Football Receiving Analysis";
	title2 "Number of Players in each Position by Class";
	label Cl= "Class" 
		  Pos= "Position";
run;

/* 8 Use means in proc statement */
proc means data=team_data Mean Median Q1 Q3 MAXDEC=2;
	var pct_avgyds;
	class Cl Pos;
	title1 "NCAA Football Receiving Analysis";
	title3 "Percent of Team Average by Class and Position";
run;

/* 9 Create table for the procedure */
proc tabulate data= PULKIT14.tot_data ;
	class Cl Pos;
	var pct_avgyds;
	table Cl*Pos ALL, pct_avgyds*(N Mean Median Q1 Q3);
run;

ods pdf close;
ods listing;