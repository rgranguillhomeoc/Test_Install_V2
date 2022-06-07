

#delimit;
capture program drop mcjob33;
program define mcjob33, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(eff_pro) tpop(1) rtit(1) ;
cap drop `drlist';
tempname mat33 ;
matrix `mat33'= e(est);
ereturn matrix est = `mat33';
end;



