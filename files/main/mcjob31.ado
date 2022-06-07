

#delimit;
capture program drop mcjob31;
program define mcjob31, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(share_tot_pro) tpop(1) rtit(1) ;
cap drop `drlist';
tempname mat31 ;
matrix `mat31'= e(est);
ereturn matrix est = `mat31';
end;



