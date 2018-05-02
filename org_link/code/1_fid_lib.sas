/* List of macros */
/* zip5 */
/* phone10 */
/* addr */
/* standard1 */

%macro fid(infn, outfn, clean);
****** PREP DB2;
*proc print data=dshs.wfid(obs=10);    

******** rename vars to be same in both files;    
data &outfn (where=(compress(name)~='') );
    set &infn(keep=fid city location fac1 fac2 fac3 phone locozip yr participate
        rename=(
        location=town
        fid=nfid
        phone=nphone
        locozip=zip
        yr=in_dshs
        ));

    ******** standardize vars;
    *%nzip5(invar=nzip, outvar=zip);
    %zip5(zip);
    
    format fid $7. phone $10.;
    city=lowcase(compress(city));
    fid=compress(nfid);
    phone=nphone;    
    %phone10(vname=phone);

    %addr(invar=town, outvar=addr);

    ************ DATA CLEANING CODE;
  %if &clean=TRUE %then %do;
    if nfid=3756272 then zip='79124';
    else if nfid=2772760 then zip='75460';
    else if nfid=0410490 then zip='77845';
    else if nfid=1131021 then zip='75234';
    else if nfid=1352660 then zip='79761';
    else if nfid=1355097 then zip='79760';
    
    if nfid=1216388 then city='carrollton';

    addr=tranwrd(addr, "samuell", "samuel");        
    
  %end;
    
    array v{*} $ fac1 fac2 fac3;
    do i= 1 to dim(v);
        fname=v{i};
        %standard1(invar=fname, outvar=name);
        if i>1 then _droprow=1;
        output;
    end;
    
  drop i nphone nfid fac1-fac3;

proc contents data=&outfn;    
proc print data=&outfn(obs=10);
    where fid in ('1131021','2016169', '3556502','1355097');
    
proc print data=&outfn(obs=10);    
where _droprow=1;

%mend;
