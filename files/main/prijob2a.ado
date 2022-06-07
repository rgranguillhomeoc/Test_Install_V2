
#delimit;
capture program drop prijob2a;
program define prijob2a, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) AGGRegate(string)  NT(int 21) *];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
if `nt' == 21 mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_tt) tpop(1)  rtit(1) ;
if `nt' == 22 mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_hh) tpop(1)  rtit(1)  ; 
if `nt' == 23 mcjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_pc) tpop(1)  rtit(1) ;
cap drop `drlist';
tempname mat ;
matrix `mat'= e(est);
ereturn matrix est = `mat';
end;


