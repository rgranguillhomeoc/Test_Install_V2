

#delimit;
capture program drop lmcjob21;
program define lmcjob21, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
lmcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(share_tot_pro)  rtot(Population) ctot(All sectors);
cap drop `drlist';
tempname mat21 ;
matrix `mat21'= e(est);
ereturn matrix est = `mat21';
end;



