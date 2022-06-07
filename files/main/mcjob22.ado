
#delimit;
capture program drop mcjob22;
program define mcjob22, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) AGGRegate(string) *];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') stat(exp_hh) tpop(1)  rtit(1)  ; 

cap drop `drlist';
tempname mat22 ;
matrix `mat22'= e(est);
ereturn matrix est = `mat22';
end;



