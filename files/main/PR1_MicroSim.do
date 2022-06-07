***********************************************
*Ethiopia microsim of increasing mobile access*
*By Araar, A. & Rogelio Granguillhome	      *
***********************************************



clear all
version 14.0
timer clear 1
timer on 1

/* ARAAR: Just to indicate my paths */
global root	 "C:\PDATA\WB\Rogilio/E_MARGIN_SIM/Datain/"
global root2 "C:\PDATA\WB\Rogilio/E_MARGIN_SIM/Dataout/"	

local mylist hasmobile pc_hh_exp_mobile
tokenize `mylist'	
use   "C:\Users\abara\Desktop\mcema_mac\userdata_f.dta", replace	
/*
qui replace new_users = 10000000 if CQ11==14	

qui replace total_users = 30000000 if CQ11==14	
*/
local totuser 	total_users
//local totuser 	tot_pop_use
//local newuser 	new_users
cap drop gr
gen gr = 1
//qui gen tot_pop_use = 56000000

local grmac  CQ11
local hweight WGT_IND
local hsize ""
tempvar sw
qui gen `sw' =  WGT_IND
//local h`Group' CQ11
tempvar eligible
gen `eligible' = 1
//replace `eligible' = 0 if CQ11==1 


		
qui levelsof `grmac', local(regions)
    tempvar Y_hat
    qui gen `Y_hat' = .
/* use of one data file   */
foreach x of local regions { 
    qui xi: probit  `1' ln_pc_totaldexp rural  Floor Wall  sex Head_HH Age  i.Education i.Electricity   HH_SIZE   i.emp_status	 if `grmac' == `x' [pw=`sw']
	qui eststo mod_`x'
    tempvar ty_hat
	qui predict  `ty_hat'
	qui replace  `Y_hat' = `ty_hat'*(`1'==0)*(`eligible'==1)  if `grmac' == `x'
	}
	
	
	
	
		
tempvar type_consumer	
levelsof `grmac', local(regions)
* Create the 3 types of consumers (Never consume / Already consume / New consumer)
 qui   qui gen      `type_consumer'  = 0
 qui   replace      `type_consumer'  = 1 if `1'==1
 tab `type_consumer' 
 
 lab define l`type_consumer' 0 "No entrant" 1 "Old user" 2 "New user"
 lab val `type_consumer' l`type_consumer'
qui levelsof `grmac', local(regions)
/* use of one data file   */

local mystr `r(levels)'
local ngr `: word count `mystr''


foreach x of local regions { 
    
if ("`totuser'" ~= "" ) {	 
qui sum `totuser'  if `grmac' == `x'  & `eligible' == 1
local target_`x'  = r(mean)
local ptarget_`x' = r(mean)
}

if ("`newuser'" ~= "" ) {	 	
qui sum `newuser'  if `grmac' == `x'  & `eligible' == 1
local m1 = r(mean)
local nptarget_`x'  = r(mean)
qui sum `1' [aw=`sw'] if `grmac' == `x'
local target_`x'    = r(sum) + `m1'
}


	qui sum `1'  if  `grmac'==`x' [aw=`sw']
	local toldu_`x'             = r(sum)
	qui sum `sw'  if  `grmac'==`x' 
	local tot_pop_`x' = r(sum)
    if (`ptarget_`x'' > (`tot_pop_`x''+1) )   local target_`x' = `tot_pop_`x''
	local ntarget_`x'    = `target_`x'' - `toldu_`x''
	
     if ("`totuser'" ~= "" ) {	
	     if (`ptarget_`x'' > (`tot_pop_`x''+1) )    dis "Warning: Group `x' : The planned `ptarget_`x''  total users is replaced by `target_`x'' (Total eligible population)."   
	 }
	  if ("`newuser'" ~= "" ) {	
	      if (`nptarget_`x'' > (`ntarget_`x''+1) )  dis "Warning: Group `x' : The planned `nptarget_`x''  total new users is replaced by `ntarget_`x'' (Total eligible new users)."  
	  }

}


	tempvar    eff_targ_all
	qui gen  `eff_targ_all'=.
	
	
	gsort `grmac' `1' - `Y_hat' 	
	foreach x of local regions { 
	 cap drop `var2_`x''
	 tempvar var2_`x'
    tempvar weight_`x' cum_weigh_`x' eff_targ_`x' var2_`x'
	qui gen double `weight_`x''= `sw'*(`grmac'==`x')*(`1'==0)*(`eligible'==1)
	qui gen double `cum_weigh_`x''     = sum(`weight_`x'') 
	qui gen double  `var2_`x''         = `ntarget_`x'' -  `cum_weigh_`x''[_n-1]  if  `grmac'==`x'
	qui replace     `var2_`x''           = 0 if  `var2_`x'' == `ntarget_`x'' & `cum_weigh_`x''==0 & `grmac'==`x'
	qui gen double `eff_targ_`x''       =  `sw'*(`eligible'==1)      if  `cum_weigh_`x''<=`target_`x''  &  `grmac'==`x' & `var2_`x''>=0
	qui replace    `eff_targ_`x''       =   `var2_`x''  if  `var2_`x''>0     & `cum_weigh_`x''>`ntarget_`x'' & `grmac'==`x'
	qui replace    `eff_targ_all'       =  `eff_targ_`x'' if `eff_targ_`x''!=. & `grmac'==`x'
	qui sum `eff_targ_`x''
	local target_reg_`x' = r(sum)
	qui sum `sw'
	local prop_new_reg_`x' = `target_reg_`x'' / `r(sum)' *100	
    qui sum `1' [aw=`sw'] if  `grmac'==`x' 
	local old_reg_`x' = r(sum)
	qui sum `sw'
	local prop_old_reg_`x' = `old_reg_`x'' / `r(sum)' *100	
	qui replace `type_consumer' =  2 if `1'==0 & `eff_targ_`x'' > 0  & `eff_targ_`x''!=.   & `grmac'==`x'
	}
	
 timer list 1

local tot_new_plan = 0
local tot_new_dist = 0
local tot_old      = 0
local tot_all      = 0

foreach x of local regions { 
local tot_new_plan = `tot_new_plan' + `ntarget_`x''
local tot_old      = `tot_old'      + `old_reg_`x'' 
local tot_all      = `tot_all'      + `old_reg_`x'' + `ntarget_`x''
}



qui sum `sw' 
local tot_pop = r(sum)

/* ARAAR: I remove the MI. At this stage, I simply use the average exp. at PSU level */  
/* Later, I will use the mi (Stata multiple imputation to have some variability of the estimated expendittures) */ 

tempname  Group
qui gen  `Group'=""
tempvar _res0 _res1 _res2 _res3 _res4 _res5 _res6
qui gen `_res0' = .		// Number of population
qui gen `_res1' = .		// Number of old users
qui gen `_res2' = .		// Number of new users
qui gen `_res3' = .		// Total number of users
qui gen `_res4' = .		// Share of old users
qui gen `_res5' = .		// Share of new users
qui gen `_res6' = .		// Share of total users



local pos = 1
levelsof `grmac', local(regions)
local lbe : value label  `grmac' 
foreach x of local regions { 
cap local f`x' : label `lbe' `x'
}
foreach x of local regions { 
qui replace `Group' = "`x'_`f`x''"  in `pos'
local rname `rname'   "`x'_`f`x''  "
qui replace `_res0' = `tot_pop_`x'' in `pos'
qui replace `_res1' = `old_reg_`x'' in `pos'
qui replace `_res2' = `target_reg_`x'' in `pos'
qui replace `_res3' = `target_reg_`x''+`old_reg_`x'' in `pos'

qui replace `_res4' =  `prop_old_reg_`x'' in `pos'
qui replace `_res5' =  `prop_new_reg_`x'' in `pos'
qui replace `_res6' =  `prop_old_reg_`x''+`prop_new_reg_`x'' in `pos'


dis "New users : " "Planned  " %15.2f	`ntarget_`x''  "   Distributed with mic. simul  "  %15.2f	`target_reg_`x''  " old users" %15.2f  `old_reg_`x''  " All" %15.2f (`target_reg_`x''+`old_reg_`x'')

local pos = `pos'+1
}
qui replace `_res0' = `tot_pop' in `pos'
qui replace `_res1' = `tot_old' in `pos'
qui replace `_res2' = `tot_new_plan'  in `pos'
qui replace `_res3' = `tot_all'  in `pos'


qui replace `_res4' = `tot_old' /`tot_pop'*100 in `pos'
qui replace `_res5' = `tot_new_plan' /`tot_pop'*100   in `pos'
qui replace `_res6' =  `tot_all' /`tot_pop'*100    in `pos'


local ngr = `pos'-1
local ngr1 = `ngr' + (`ngr'>1)
/*
 dis "Total 1 = "  %20.2f  `tot_old'  " Total 2 = "  %20.2f  `tot_new_plan'  " Total 3 = "  %20.2f  `tot_all' 
 */
local rname `rname'   "Total  "
tempname resa1 resa2
 mkmat `_res0'-`_res3' in 1/`ngr1', matrix(`resa1')
 mkmat `_res4'-`_res6' in 1/`ngr1', matrix(`resa2')
 if (`ngr'>1) {
 matrix rownames `resa1' = `rname' 
 matrix rownames `resa2' = `rname' 
 }
 
  if (`ngr'==1) {
 matrix rownames `resa1' = "Population"
 matrix rownames `resa2' = "Population" 
 }
tempname   coltit  coltit2
 qui gen     `coltit' = "Population" in 1
 qui replace `coltit' = "Old Users"  in 2
 qui replace `coltit' = "New Users"  in 3
 qui replace `coltit' = "All Users"  in 4
 
 qui gen      `coltit2' = "Consumers" in 1
 qui replace  `coltit2' = "Consumers" in 2
 qui replace  `coltit2' = "consumers" in 3
 
 esttab mod_* , not pr2
 local dsmidl = 0
 if `ngr1' == 1  local dsmidl = -1 
 dis "Table ##:  Number of old and new consumers"
  distable `resa1', dec1(1) dec2(1) dec3(1) dec4(1) coltit1(`coltit') dsmidl(`dsmidl')  coltit2(`coltit2')

 dis "Table ##:  Percentages of old and new consumers"
  distable `resa2', dec1(3) dec2(3) dec3(3) coltit1(`coltit')  dsmidl(`dsmidl')  coltit2(`coltit2')

 cap drop _est_*
 cap drop _I*;
 cap drop ___*;

save data_c3, replace

