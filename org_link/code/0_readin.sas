/* Read CMS File in CSV and filter for TX hospitals to save in SAS*/

libname org_link '/folders/myfolders/org_link';
FILENAME REFFILE '/folders/myfolders/org_link/data/HOSPITAL10_PROVIDER_ID_INFO.CSV';

/* Step 1: Read cms file in csv format */

%readxlsx(infn= HOSPITAL10_PROVIDER_ID_INFO, sht=HOSPITAL10_PROVIDER_ID_INFO, outfn= output.mcareid);

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=org_link.mcareid;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA= org_link.mcareid; 
RUN;

%web_open_table(org_link.mcareid);

/*  check if import is proper or not */
/*  total 6546 hospital information */

/* Step 2: Filter for only TX hospitals */

data org_link.txhosp;
    set org_link.mcareid;
    where state='TX';

rename provider_number= mcareid
    hosp_name= hname
    street_addr= addr
    zip_code= zip
    ;    
/*  total 669 hospitals in Texas */
/*  data saved as SAS dataset txhosp.sas7bdat*/

proc print data= org_link.txhosp (obs=10);
