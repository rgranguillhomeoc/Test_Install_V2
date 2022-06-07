
#delimit;
capture program drop prijob4a;
program define prijob4a, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1)  GVIMP(int 0) GVPC(int 0)  SUBS(real 0.4)  MATPEL(string) MATIEL(string) SOTM(int 1) NT(int 41) ];
aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
if `nt'==41 prjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_tt) ctot(no) ;
if `nt'==42 prjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_pc) ctot(no) ;
if `nt'==43 prjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(share_tot_exp) pcexp(`pcexp')  ctot(no)  ;
if `nt'==44 prjobstat `varlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')   stat(exp_pcs3) pcexp(`pcexp')  ctot(no) ;
tempname mat ;
matrix `mat'= e(est);
ereturn matrix est = `mat';
end;





