
#delimit;
capture program drop prijob6a;
program define prijob6a, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname)  WAPPR(int 1) MODEL(int 1) GVIMP(int 0) SUBS(real 0.4)  EPSILON(real 0.5) STEP(int 1) MATPEL(string) MATIEL(string) SOTM(int 1) EPSILON(real 0.5)  THETA(real 0)  NT(int 61)];

aggrvar `varlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist  `r(slist)';
local  flist  `r(flist)';
local drlist  `r(drlist)';
if `nt' == 61 prjobgini      `varlist',   hs(`hsize')   lan(`lan')   xrnames(`slist')  pcexp(`pcexp')    ;
if `nt' == 62 prjobatkinson  `varlist',  hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')      epsilon(`epsilon');
if `nt' == 63 prjobentropy   `varlist',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')      theta(`theta') ;
if `nt' == 64 prjobratio  `varlist',   hs(`hsize') aehs(`aehs')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp') ;
tempname mat ;
matrix `mat'= e(est);
ereturn matrix est = `mat';
end;



