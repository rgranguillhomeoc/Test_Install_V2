
#delimit;
capture program drop mcjob110;
program define mcjob110, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) *];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
mcjobstat `flist',   hgroup(`hgroup') lan(`lan')   xrnames(`slist') stat(exp_pc) ;
cap drop `drlist';
tempname mat110 ;
matrix `mat110'= e(est);
local rowsize = rowsof(`mat110');
local colsize = colsof(`mat110')-1 ;
matrix `mat110' = `mat110'[1..`rowsize', 1..`colsize'];
ereturn matrix est = `mat110';

end;




