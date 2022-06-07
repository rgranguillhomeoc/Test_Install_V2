

#delimit;
capture program drop lmcjob22;
program define lmcjob22, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(exp_pc) rtot(Population) ctot(All sectors) ;
cap drop `drlist';
tempname mat31 ;
matrix `mat31'= e(est);
ereturn matrix est = `mat31';
end;



