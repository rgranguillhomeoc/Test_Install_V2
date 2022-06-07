

#delimit;
capture program drop prijob3a;
program define prijob3a, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) NT(int 31) ];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
if `nt' == 31 mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(share_tot_pro) tpop(1) rtit(1) ;
if `nt' == 32 mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(share_tot_exp) tpop(1) rtit(1) ;
if `nt' == 33 mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist') pcexp(`pcexp')  stat(eff_pro)       tpop(1) rtit(1) ;
tempname mat ;
matrix `mat'= e(est);
ereturn matrix est = `mat';
end;



