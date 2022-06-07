


#delimit ;
cap program drop addmimenu ;
program  define  addmimenu ;
version 11.0;
args nfile lcom;
local mydir `c(pwd)';
local fl `nfile';
cap findfile `fl' ;
local dire `r(fn)';
qui sysdir;
if  ("`dire'"!="") {;
addmimenu3 `fl' `lcom';
};
if  ("`dire'"=="") {;
qui version;
if  ("`c(os)'"=="Windows") {;
qui sysdir;
local mdr = subinstr("`c(sysdir_personal)'","/","\",.);
                if ("`mdr'"=="c:\ado\personal\") {;
                                cap cd c:/;
                                cap mkdir ado;
                                cap cd ado;
                                cap mkdir personal;
                                cap cd personal;
                                } ;              
        }  ;     
        
cd `c(sysdir_personal)';
tempfile   myfile;
qui file open  myfile   using "`fl'", write replace ;
qui file write myfile `"`lcom'"' _n;
qui file close  myfile;
cap findfile `fl';
if  "`r(fn)'"!=""  {;
dis "The file `fl' was added succefully.";
};
};

capture {;
window menu clear;
findfile profile.do;
do `r(fn)';
};

qui cd `mydir';
end;
