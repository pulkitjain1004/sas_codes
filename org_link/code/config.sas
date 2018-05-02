%include '/opt/HPM/proj1/mylink/link_lib.sas';
%include '/opt/HPM/proj1/mylink/orglink.sas';
libname dsrip '/opt/HPM/proj1/dsrip/data';
libname npi '/opt/HPM/proj1/npi/data';
libname mcare '/opt/HPM/proj1/hsr_mcare/data';

* OUTPUT;
* libname data location;
%let linkfn=fid2mcareid;
%let clustfn=clust;
    
* INPUT;
%let db1=data.fid;
%let id1=fid;
%let db2=data.mcareid;
%let id2=mcareid;
%let byvar=name;  * block vars;
%let vnum=3;
%let var1=zip;
%let var2=addr;
%let var3=fname;
%let keepvar1=in_dshs;
%let keepvar2=;
%let othvar=; *npi1 in_dshs;
%let order=; *zip tpi fid rhp fname name addr town phone in_dshs naddr;

* nothing in first iteration;
* 1 in next itertation which incorporates confirm information;
%let iter=;

%macro standard1(invar, outvar);
    %_alphalowbl(&invar, &outvar);

    &outvar=tranwrd(&outvar, " inc", " ");
    &outvar=tranwrd(&outvar, " llp", " ");            
    &outvar=tranwrd(&outvar, " llc", " ");            
    &outvar=tranwrd(&outvar, " at ", " ");
    &outvar=tranwrd(&outvar, " of ", " ");    
    &outvar=tranwrd(&outvar, "ctr", "center");
    &outvar=tranwrd(&outvar, "cntr", "center");    
    &outvar=tranwrd(&outvar, "medical", "med");
    &outvar=tranwrd(&outvar, "tx", "texas");    
    &outvar=tranwrd(&outvar, "hospital", "hosp");
    &outvar=tranwrd(&outvar, "branch", "br");
    &outvar=tranwrd(&outvar, "county", "co");
    &outvar=tranwrd(&outvar, "the ", " ");
    &outvar=tranwrd(&outvar, "memorial", " ");
    &outvar=tranwrd(&outvar, "rehabilitation", "rehab"); 
    &outvar=tranwrd(&outvar, "regional", "");
    &outvar=tranwrd(&outvar, "district","");
        
    &outvar=compbl(&outvar);   
    &outvar=tranwrd(&outvar, "university texas", "ut");
    &outvar=tranwrd(&outvar, "east texas med center","etmc");    
    &outvar=tranwrd(&outvar, "select specialty","ssh");
    * PAPER: must come after ETMC;
    &outvar=tranwrd(&outvar, "med", "");
    &outvar=tranwrd(&outvar, "center", "");
    &outvar=tranwrd(&outvar, "hosp", "");
    &outvar=tranwrd(&outvar, "texas", "");    
    &outvar=compbl(&outvar);       
    if length(&outvar)<5 then &outvar=lowcase(&invar);    
%mend;
    
