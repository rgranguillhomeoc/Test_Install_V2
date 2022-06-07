

#delim ;

capture program drop basicstats;
program define  basicstats, rclass;
version 9.2;
syntax varlist  [, HSize(varname) HGroup(varname)  STAT(string) DENOM(varname)];
preserve;

tokenize `varlist';

tempvar _hs;

gen `_hs'=`hsize';

local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 

tempvar _num _denum _fw _w;

if "`stat'" == "" local stat = "exp_tt";
qui gen `_fw'=`_hs';
if (`"`hweight'"'~="") qui replace `_fw'=`_fw'*`hweight';

qui gen `_w'=1;
if (`"`hweight'"'~="") qui replace `_w'=`hweight';

if "`stat'" == "exp_tt" {;
forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk');
qui sum `1' [aw=`_fwg'];
return scalar est`i' =  r(sum);
};
qui sum  `1'  [aw=`_fw'] ;
local pe = $indig+1;
return scalar est`pe' =  r(sum);
};

if "`stat'" == "exp_pc" {;

forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk');
qui sum `1' [aw=`_fwg'];
return scalar est`i' =  r(mean);
};

qui sum  `1'  [aw=`_fw'] ;
local pe = $indig+1;
return scalar est`pe' =  r(mean);
};

if "`stat'" == "exp_pcgz" {;

forvalues i=1/$indig {;
tempvar _fwg _fw;
local kk = gn1[`i'];
cap drop `_fw';
local name = subinstr( "`1'","lpci_","S_",.) ;
qui gen `_fw'=`_w'*`name'*(`1'>0);
qui gen `_fwg'=`_fw'*(`hgroup'==`kk');
qui sum `1' [aw=`_fwg'];
             local myres = r(mean);
if `r(N)'==0 local myres = 0;
return scalar est`i' =  `myres';

};

qui sum  `1'  [aw=`_fw'] ;
              local myres = r(mean);
if `r(N)'==0  local myres = 0;
local pe = $indig+1;
return scalar est`pe' =  `myres';
};


if "`stat'" == "exp_pcs" {;
forvalues i=1/$indig {;
tempvar _hsg;
local kk = gn1[`i'];
qui gen `_hsg'=`_hs'*(`hgroup'==`kk');
tempvar v1 v2;
qui gen `v1' = `_hsg'*`1';
qui gen `v2' = `_hsg';
qui svy: ratio `v1'/`v2' ;
return scalar est`i' =  el(r(table),1,1);
return scalar pv`i' =   el(r(table),4,1);
};

tempvar v1 v2;
qui gen `v1' = `_hs'*`1';
qui gen `v2' = `_hs';
qui svy: ratio `v1'/`v2' ;
local pe = $indig+1;
return scalar est`pe' =  el(r(table),1,1);
return scalar pv`pe' =   el(r(table),4,1);
};

if "`stat'" == "exp_pcs2" {;
forvalues i=1/$indig {;
tempvar _hsg;
local kk = gn1[`i'];
qui gen `_hsg'=`_hs'*(`hgroup'==`kk');
tempvar v1 v2;
qui gen `v1' = `_hsg'*`1'*(`1'>0);
qui gen `v2' = `_hsg'*(`1'>0);
qui svy: ratio `v1'/`v2' ;
return scalar est`i' =  el(r(table),1,1);
return scalar pv`i' =   el(r(table),4,1);
};

tempvar v1 v2;
qui gen `v1' = `_hs'*`1'*(`1'>0);
qui gen `v2' = `_hs'*(`1'>0);
qui svy: ratio `v1'/`v2' ;
local pe = $indig+1;
return scalar est`pe' =  el(r(table),1,1);
return scalar pv`pe' =   el(r(table),4,1);
};

if "`stat'" == "exp_pcs3" {;
forvalues i=1/$indig {;
tempvar _hsg;
local kk = gn1[`i'];
qui gen `_hsg'=`_hs'*(`hgroup'==`kk');
tempvar v1 v2;
qui gen `v1' = `_hsg'*`1'*(`1'!=0);
qui gen `v2' = `_hsg'*(`1'!=0);
qui svy: ratio `v1'/`v2' ;
return scalar est`i' =  el(r(table),1,1);
return scalar pv`i' =   el(r(table),4,1);
};
tempvar v1 v2;
qui gen `v1' = `_hs'*`1'*(`1'!=0);
qui gen `v2' = `_hs'*(`1'!=0);
qui svy: ratio `v1'/`v2' ;
local pe = $indig+1;
return scalar est`pe' =  el(r(table),1,1);
return scalar pv`pe' =   el(r(table),4,1);
};


if "`stat'" == "exp_hh" {;
tempvar var;
qui gen `var' = `1'*`_hs';
forvalues i=1/$indig {;
local kk = gn1[`i'];
tempvar _wg;
qui gen `_wg'=`_w'*(`hgroup'==`kk');
qui sum `var' [aw=`_wg'];
return scalar est`i' =  r(mean);
};
qui sum  `var'  [aw=`_w'] ;
local pe = $indig+1;
return scalar est`pe' =  r(mean);
};

if "`stat'" == "share_tot_pro" | "`stat'" == "share_tot_exp" {;


forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk');
qui sum `1'     [aw=`_fwg'];  local st1= r(sum);
qui sum `denom' [aw=`_fwg' ]; local st2= r(sum);
return scalar est`i' =  `st1' / `st2' *100;
local pe = $indig+1;
qui sum `1'     [aw=`_fw'];  local st1= r(sum);
qui sum `denom' [aw=`_fw' ]; local st2= r(sum);
return scalar est`pe' =  `st1' / `st2' *100;
};
};

if "`stat'" == "eff_pro" {;
forvalues i=1/$indig {;
tempvar _fwg  _fwg1;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk');
qui gen `_fwg1'=`_fw'*(`hgroup'==`kk')*(`1'>0);

qui sum `_fwg' ;  local st2= r(sum);
qui sum `_fwg1';  local st1= r(sum);
return scalar est`i' =  `st1' / `st2' *100;
};
local pe = $indig+1;
tempvar _fwg  _fwg1;
qui gen `_fwg'=`_fw';
qui gen `_fwg1'=`_fw'*(`1'>0);
qui sum `_fwg' ;  local st2= r(sum);
qui sum `_fwg1';  local st1= r(sum);
return scalar est`pe' =  `st1' / `st2' *100;
};




restore;

end;
