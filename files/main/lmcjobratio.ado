

/*************************************************************************/
/* module  : __dinineq                                                   */
/*************************************************************************/



#delim ;

/*****************************************************/
/* Density function      : fw=Hweight*Hsize      */
/*****************************************************/
cap program drop _dinineq_den;                    
program define _dinineq_den, rclass;              
args fw x xval;                         
qui su `x' [aw=`fw'], detail;           
local tmp = (`r(p75)'-`r(p25)')/1.34;                          
local tmp = (`tmp'<`r(sd)')*`tmp'+(`tmp'>=`r(sd)')*`r(sd)' ;    
local h   = 0.9*`tmp'*_N^(-1.0/5.0);                            
tempvar s1 s2;                                                  
gen `s1' = sum( `fw' *exp(-0.5* ( ((`xval'-`x')/`h')^2  )  ));  
gen `s2' = sum( `fw' );
return scalar den = `s1'[_N]/( `h'* sqrt(2*c(pi)) * `s2'[_N] );  
end;


/***************************************/
/* Quantile  & GLorenz                 */
/***************************************/
cap program drop _dinineq_qua;
program define _dinineq_qua, rclass sortpreserve;
args fw yyy xval order;
preserve;
sort `yyy', stable;
qui cap drop if `yyy'>=. | `fw'>=.;
tempvar ww qp glp pc;
qui gen `ww'=sum(`fw');
qui gen `pc'=`ww'/`ww'[_N];
qui gen `qp' = `yyy' ;
qui gen `glp' double = sum(`fw'*`yyy')/`ww'[_N];
qui sum `yyy' [aw=`fw'];
local i=1;
while (`pc'[`i'] < `xval') {;
local i=`i'+1;
};
local ar=`i'-1;
if (`i'> 1) {;
local qnt =`qp'[`ar'] +((`qp'[`i'] -`qp'[`ar']) /(`pc'[`i']-`pc'[`ar']))*(`pc'[`i']-`pc'[`ar']);
local glor=`glp'[`ar']+((`glp'[`i']-`glp'[`ar'])/(`pc'[`i']-`pc'[`ar']))*(`pc'[`i']-`pc'[`ar']);
};
if (`i'==1) {;
local qnt =(max(0,`qp'[`i'])/(`pc'[`i']))*(`pc'[`i']);
local glor=(max(0,`glp'[`i'])/(`pc'[`i']))*(`pc'[`i']);
};

return scalar qnt  = `qnt';
return scalar glor = `glor';
restore;
end;



cap program drop _dinineq2;  
program define _dinineq2, rclass sortpreserve;    
version 9.2;         
syntax varlist (min=1 max=1) [, HSize(varname) HWeight(varname) HGroup(varname) 
p1(real 0.1) p2(real 0.2) p3(real 0.8) p4(real 0.9) index(string)  
GNumber(int -1) CI(real 5)  CONF(string) LEVEL(real 95) vab(int 0)] ;

tokenize `varlist';
                     qui drop if `1'>=. ;
if ("`hsize'"!="")   qui drop if `hsize'>=.;
if ("`hweight'"!="") qui drop if `hweight'>=.;
tempvar  hs sw fw ;
gen `sw'=1;
gen `hs'=1;

if ("`hsize'"!="")     qui replace `hs' = `hsize';
tempvar _in;
if ("`hgroup'" != "")  qui gen    `_in' = (`hgroup' == `gnumber');
if ("`hgroup'" != "")  qui replace `hs' = `hs' * `_in';
if ("`hweight'"!="")   qui replace `sw'=`hweight';


local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
tempvar fw;
gen `fw'=`hs';
if (`"`hweight'"'~="") qui replace `fw'=`fw'*`hweight';

tempvar vec_a vec_b;

if ( "`index'"=="qr") {;
_dinineq_qua `fw' `1' `p1';
local q1=`r(qnt)';
_dinineq_qua `fw' `1' `p2';
local q2=`r(qnt)';
local est = `q1'/`q2';
_dinineq_den `fw' `1' `q1';
local fq1=`r(den)';
_dinineq_den `fw' `1' `q2';
local fq2=`r(den)';
gen `vec_a' = -`hs'*((`q1'>`1')-`p1')/`fq1' + `hs'*`q1';
gen `vec_b' = -`hs'*((`q2'>`1')-`p2')/`fq2' + `hs'*`q2';
qui svy: ratio `vec_a'/`vec_b';
cap drop matrix _vv;
matrix _vv=e(V);
local std = el(_vv,1,1)^0.5;
global ws1=`q1';
global ws2=`q2';


};



if ( "`index'"=="sr") {;

_dinineq_qua `fw' `1' `p1';
local q1=`r(qnt)'; local g1=`r(glor)';
_dinineq_qua `fw' `1' `p2';
local q2=`r(qnt)'; local g2=`r(glor)';
_dinineq_qua `fw' `1' `p3';
local q3=`r(qnt)'; local g3=`r(glor)';
_dinineq_qua `fw' `1' `p4';
local q4=`r(qnt)'; local g4=`r(glor)';

local est = (`g2'-`g1')/(`g4'-`g3');
global ws1=(`g2'-`g1');
global ws2=(`g4'-`g3');

gen `vec_a' = `hs'*(`q2'*`p2'+(`1'-`q2')*(`q2'>`1')) - `hs'*(`q1'*`p1'+(`1'-`q1')*(`q1'>`1')) ;
gen `vec_b' = `hs'*(`q4'*`p4'+(`1'-`q4')*(`q4'>`1')) - `hs'*(`q3'*`p3'+(`1'-`q3')*(`q3'>`1')) ;;
qui svy: ratio `vec_a'/`vec_b';
cap drop matrix _vv;
matrix _vv=e(V);
local std = el(_vv,1,1)^0.5;




};

if (`vab'==1) {;

gen __va=`vec_a';
gen __vb=`vec_b';

};
qui svydes;
local fr=`r(N_units)'-`r(N_strata)';
local lvl=(100-`level')/100;
if ("`conf'"=="ts") local lvl=`lvl'/2;
local tt=invttail(`fr',`lvl');


return scalar est  = `est';
return scalar std  = `std';
return scalar lb   = `est' - `tt'*`std';
return scalar ub   = `est' + `tt'*`std';
return scalar df   = `fr';



end;     





capture program drop basicratio;
program define basicratio, rclass sortpreserve;
version 9.2;
syntax  namelist(min=2 max=2) [, FILE1(string) FILE2(string) 
p1(real 0.1) p2(real 0.2) p3(real 0.8) p4(real 0.9) index(string)
HSize1(string) HSize2(string)
COND1(string)  COND2(string)  
type(string)  LEVEL(real 95) CONF(string) TEST(string) DEC(int 6)];

global indica=3;
tokenize `namelist';
if ("`conf'"=="")          local conf="ts";
if ("`index'"=="") local index = "qr";
preserve;
local indep = ( (`"`file1'"'=="" & `"`file2'"'=="") | (`"`file1'"'==`"`file2'"')  );
local vab=0;
if ( (`"`file1'"'=="" & `"`file2'"'=="") | (`"`file1'"'==`"`file2'"')  ) local vab=1;
if ("`file1'" !="") use `"`file1'"', replace;
tempvar cd1;
tempvar ths1;
qui gen `ths1'=1;

if ( "`hsize1'"!="") qui replace `ths1'=`hsize1';

if ( "`cond1'"!="") {;
gen `cd1'=`cond1';
qui replace `ths1'=`ths1'*`cd1';
qui sum `cd1';
if (`r(sum)'==0) {;
dis as error " With the condition(s) of distribution_1, the number of observations is 0.";
exit;
};
};

qui svyset ;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);

local hweight1=""; 
cap qui svy: total `1'; 
local hweight1=`"`e(wvar)'"';
cap ereturn clear; 

_dinineq2 `1' , hweight(`hweight1') hsize(`ths1')  p1(`p1') p2(`p2') p3(`p3') p4(`p4') index(`index') conf(`conf') level(`level') vab(`vab');
matrix _res_d1  =(`r(est)',`r(std)',`r(lb)',`r(ub)', `r(df)') ;
if (`vab'==1) {;
tempvar va vb;
qui gen `va'=__va;
qui gen `vb'=__vb;
qui drop __va __vb;
local sv1=$ws1;
local sv2=$ws2;
};



if ("`file2'" !="" & `vab'!=1) use `"`file2'"', replace;
tempvar cd2 ths2;
qui gen `ths2'=1;
if ( "`hsize2'"!="") qui replace `ths2'=`hsize2';
if ( "`cond2'"!="") {;
gen `cd2'=`cond2';
qui replace `ths2'=`ths2'*`cd2';
qui sum `cd2';
if (`r(sum)'==0) {;
dis as error " With the condition(s) of distribution_2 the number of observations is 0.";
exit;
};
};
qui svyset ;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);
local hweight2=""; 
cap qui svy: total `2'; 
local hweight2=`"`e(wvar)'"';
cap ereturn clear; 



_dinineq2 `2' , hweight(`hweight2') hsize(`ths2') p1(`p1') p2(`p2') p3(`p3') p4(`p4') index(`index')  conf(`conf') level(`level') vab(`vab') ;
if (`vab'==1) {;
tempvar vc vd;
qui gen `vc'=__va;
qui gen `vd'=__vb;
qui drop __va __vb;
local sv3=$ws1;
local sv4=$ws2;
};

matrix _res_d2 =(`r(est)',`r(std)',`r(lb)',`r(ub)', `r(df)');
local dif = el(_res_d2,1,1)-el(_res_d1,1,1);
local std = (el(_res_d1,1,2)^2+el(_res_d2,1,2)^2)^0.5;


if (`vab'==1) {;
qui svy: mean `va' `vb' `vc' `vd';
cap drop matrix mat;
matrix mat=e(V);
cap drop matrix gra;
matrix gra=
(
1/`sv2'\
-`sv1'/`sv2'^2\
-1/`sv4'\
`sv3'/`sv4'^2
);
cap matrix drop _zz;
matrix _zz=gra'*mat*gra;
local std= el(_zz,1,1)^0.5; 
}; 

local sdif = `std';

local est1=el(_res_d1,1,1);
local est2=el(_res_d2,1,1);

local std1=el(_res_d1,1,2);
local std2=el(_res_d2,1,2);

local df1=el(_res_d1,1,5);
local df2=el(_res_d2,1,5);
     

	 
qui svydes;
local fr=`r(N_units)'-`r(N_strata)';
local tval = (`est1'-`est2')/`sdif';
return scalar tval = `tval';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `sdif'==0 local pval = 0; 
return scalar pval = `pval';



return scalar  a0 = `est1';
return scalar sa0 = `std1';

return scalar  a1 = `est2';
return scalar sa1 = `std2';

return scalar dif = `est1'-`est2';
return scalar sdif = `sdif';

return scalar est1 = `est1';
return scalar est2 = `est2';
ereturn clear;
restore;





end;






capture program drop lmcjobratio;
program define lmcjobratio, eclass;
version 9.2;
syntax varlist(min=1)[, 
HSize(varname)  
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
theta(real 0.5)
];




preserve;

tokenize `varlist';
_nargs    `varlist';
local indica2 = $indica+1;
global indix $indica;
tempvar total;
qui gen `total'=0;
tempvar Variable EST1 EST11 EST111  EST1111;
qui gen `EST1'=0;
qui gen `EST11'=0;
qui gen `EST111'=0;
qui gen `EST1111'=0;







tempvar Variable ;
qui gen `Variable'="";

tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';

cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);




basicratio `pcexp' `pcexp',  hsize1(`_ths') hsize2(`_ths')  p1(0.1) p2(0.9);
qui replace `Variable' = "Pre-reform" in 1;
qui replace `EST1'=  `r(est1)'  in      1;
qui replace `EST11'=   .  in    1;
qui replace `EST111'=  .  in    1;
qui replace `EST1111'=  .  in   1;

forvalues k = 1/$indix {;
local j = `k' +1;
tempvar sliving;
qui gen `sliving' = `pcexp'+``k'';
basicratio `sliving' `pcexp',  hsize1(`_ths') hsize2(`_ths')  p1(0.1) p2(0.9);
qui replace `EST1'=  `r(est1)'  in `j';
qui replace `EST11'=  `r(dif)'  in `j';
qui replace `EST111'=  `r(sdif)'  in `j';
qui replace `EST1111'=  `r(pval)'  in `j';

};










/****TO DISPLAY RESULTS*****/

local cnam = "";

                                         
if ("`lan'"~="fr")  local cnam `"`cnam' "The ratio index""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Variation in ratio""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P_Value""';

if ("`lan'"=="fr")  local cnam `"`cnam' "Indice de ratio""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Variation en ratio""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Erreur type""';
if ("`lan'"=="fr")  local cnam `"`cnam' "P_Value""';


local lng = (`indica2');
qui keep in 1/`lng';

local dste=0;



tempname zz;
qui mkmat   `EST1' `EST11' `EST111' `EST1111',   matrix(`zz');



local rnam;
local rnam `"`rnam' "Pre reform""';
local count : word count `varlist';
tokenize `varlist' ;
forvalues i = 1/`count' {;
            local tmp = substr("``i''",1,30);
            local rnam `"`rnam' "`tmp'""';
};





matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;

ereturn matrix est = `zz';

restore;

end;



