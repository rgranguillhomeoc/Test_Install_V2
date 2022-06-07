


#delimit;
capture program drop mcjob32;
program define mcjob32, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp') stat(share_tot_exp) tpop(1)  rtit(1) ;
cap drop `drlist' ;
tempname mat32 ;
matrix `mat32'= e(est);
ereturn matrix est = `mat32';
end;



