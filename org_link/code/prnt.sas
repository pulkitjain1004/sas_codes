%let type=name;
%let val='crosbyton';

%let type=&id2;
%let val='45134';

proc print data=&db1;
    where find (&type, &val)>0;

proc print data=&db2;
    where find (&type, &val)>0;    
    
proc print data=data.&linkfn&iter(obs=10);
    where find (&type, &val)>0;
    
proc print data=data.&linkfn.x&iter(obs=10);
    where find (&type, &val)>0;        
