libname in '../dshs/data';

proc print data=in.hs13 (obs=10);
    where fid=1136366;
