/* Raname variables in txhosp.sas7bdat which is CMS file filtered for Texas */
/* Two outputs are created depending on mcareid */
/* This file uses macros coded in config.sas */

/* List of macros: */
/* standard1 is in config.sas */
/* zip5 */
/* addr */
/* alphalowbl (it's in config.sas) */

libname org_link '/folders/myfolders/org_link';

%macro mcareid(infn, outfn, clean);
****** PREP DB;
*proc print data=dshs.wfid(obs=10);    

******** rename vars to be same in both files;    
data &outfn(drop=nmcareid) &outfn.x;
    set org_link.txhosp(keep=mcareid city addr hname zip
        rename=(
        mcareid= nmcareid
        hname= fname
        ));

    %standard1(invar=fname, outvar=name);    
    if nmcareid=450770 then name='centraltexas';
    
    ******** make all vars char & standardize vars;
    %zip5(vname=zip);
    %addr(invar=addr, outvar=addr);
    
    format mcareid $6.;
    mcareid= compress(nmcareid);

    ******** set as appropriate or keep for mult rows;
    _droprow=.;

    ************ DATA CLEANING CODE;
  %if &clean=TRUE %then %do;    
    if nmcareid=454110 then addr='3300 s fm 1788';
    else if nmcareid=450620 then addr='704 hospital dr';
    else if nmcareid=450379 then addr='7 medical pkwy';
    else if nmcareid=454120 then addr='7601 fannin st';    
    else if nmcareid=450044 then zip=75390;
    else if nmcareid=670034 then zip=78665;
    else if nmcareid=450851 then zip=75226;
    else if nmcareid=454116 then zip=75902;
    else if nmcareid=450841 then zip=78526;

    if mcareid in ('670082','454121','670085','454120', '454122') then output &outfn.x;
    else output &outfn;
  %end;
    
proc contents data=&fn;
proc print data=&fn.x(obs=10);    
proc print data=&fn(obs=10);
    where mcareid in ('452061','454110', '450620');        
proc print data=&fn(obs=10);    
where _droprow=1;

%mend;


/* To execute the macro run the below statement */
/* %mcareid(infn, outfn, clean); */

%mcareid(guess, trial, TRUE);


/******* LIB HEADER;
    %zip5(vname=zip);
    %nzip5(invar=addr, outvar=addr);
    %phone10(invar=addr, outvar=addr);    
    %addr(invar=addr, outvar=addr);    

    %_alphalow(invar=addr, outvar=addr);    
*******************/
