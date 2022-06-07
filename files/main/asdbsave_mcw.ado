



#delimit ;


capture program drop asdbsave_mcw;
program define asdbsave_mcw, rclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
HSize(string)  
PLine(varname)
HGroup(string)
NITEMS(int 1)
MOVE(int 1)
MEAS(int 1)
MODEL(int 1)
SUBS(real 0.6)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
GVIMP(int 0)
GVPC(int 0)
CONF(string) 
LEVEL(real 95)
DEC(int 3)
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)
GSCEN(int 0)
MPART(int 0)
XFIL(string)
TJOBS(string) 

GJOBS(string) 
FOLGR(string)

OPGR1(string) OPGR2(string)  OPGR3(string) 

];

tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

local mylist min max ogr;
forvalues i=1/3 {;
if ("`opgr`i''"~="") {;
extend_opt_graph test , `opgr`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};

local mylist secp pr;

   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.mcw" ;
   file open myfile   using "`inisave'.mcw", write replace ;
   if ("`inisave'"~="")  file write myfile `".mcwel_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   file write myfile `".mcwel_dlg.main.vn_pcexp.setvalue "`1'""' _n;
   file write myfile `".mcwel_dlg.main.vn_hhs.setvalue "`hsize'""' _n;
   file write myfile `".mcwel_dlg.main.vn_pl1.setvalue "`pline'""' _n;
   file write myfile `".mcwel_dlg.main.vn_hhg.setvalue "`hgroup'""' _n;
   
   file write myfile `".mcwel_dlg.main.cb_meas.setvalue "`meas'""' _n; 
   file write myfile `".mcwel_dlg.main.cb_model.setvalue "`model'""' _n;
   file write myfile `".mcwel_dlg.main.ed_subs.setvalue "`subs'""' _n; 
   file write myfile `".mcwel_dlg.main.cb_move.setvalue "`move'""' _n; 
   file write myfile `".mcwel_dlg..items_info_mcwel.ed_mpart.setvalue "`mpart'""' _n; 
   
   file write myfile `".mcwel_dlg.main.ed_epsilon.setvalue "`epsilon'""' _n; 
   file write myfile `".mcwel_dlg.main.ed_theta.setvalue "`theta'""' _n; 
    
     if ("`folgr'"~="")  {;
   file write myfile `".mcwel_dlg.gr_options_mc.ck_folgr.seton"' _n;
   file write myfile `".mcwel_dlg.gr_options_mc.ed_folgr.setvalue "`folgr'""' _n;
   };

   
    if ("`tjobs'"~="") {;
   file write myfile `".mcwel_dlg.tb_options_mc.ck_tables.seton"' _n;
   file write myfile `".mcwel_dlg.tb_options_mc.ed_tab.setvalue "`tjobs'""' _n;
   };
   
   if ("`gjobs'"~="") {;
   file write myfile `".mcwel_dlg.gr_options_mc.ck_graphs.seton"' _n;
   file write myfile `".mcwel_dlg.gr_options_mc.ed_gra.setvalue "`gjobs'""' _n;
   };
   
   if ("`xfil'"~="") {;
   file write myfile `".mcwel_dlg.tb_options_mc.ck_excel.seton"' _n;
   file write myfile `".mcwel_dlg.tb_options_mc.fnamex.setvalue "`xfil'""' _n;
   };
   
  if (`gvimp'==1)     file write myfile `".mcwel_dlg.main.chk_gvimp.seton "' _n; 
  if (`gvpc'==1)      file write myfile  `".mcwel_dlg.main.chk_gvpc.seton "' _n;  

   forvalues i=1/10 {;
   if ("`min`i''"~="")  file write myfile `".mcwel_dlg.gr_options_mc.en_min`i'.setvalue "`min`i''""' _n;
   if ("`max`i''"~="")  file write myfile `".mcwel_dlg.gr_options_mc.en_max`i'.setvalue "`max`i''""' _n;
   if ("`ogr`i''"~="")  file write myfile `".mcwel_dlg.gr_options_mc.en_opt`i'.setvalue `"`ogr`i''"' "' _n;
   };
   
   file close myfile;  
   
  
  
  

  
  

local mylist sn vn el st nf si scen;
forvalues i=1/`nitems' {;
extend_opt_item_mcwel test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';
if  "``name'`i''"=="." local `name'`i' = "" ;
};


forvalues i=1/`nitems' {;
if "`sn`i''"==""      local sn`i' = "" ;
if "`el`i''"==""      local el`i' = 0 ;
if ("`it`i''" == "" ) local vn`i' = "`vn`i''" ;
if ("`st`i''" == "" ) local st`i' = "`st`i''" ;
if ("`nf`i''" == "" ) local nf`i' = "`nf`i''" ;
if ("`si`i''" == "" ) local mi`i' = "`si`i''" ;
if ("`scen`i''" == "" ) local scen`i' = "`scen`i''" ;
};


 
   cap file close myfile;
   tempfile  myfile;
   

   file open myfile   using "`inisave'.mcw", write append;
   
   if (`gscen' == 1) {;
   file write myfile `".mcwel_dlg.items_info_mcwel.def_step.seton"' _n;
   };
   
 
		forvalues i=1/`nitems' {;
		file write myfile `".mcwel_dlg.items_info_mcwel.en_sn`i'.setvalue  "`sn`i''""'  _n;  
		file write myfile `".mcwel_dlg.items_info_mcwel.vn_item`i'.setvalue  "`vn`i''""'  _n;   
		file write myfile `".mcwel_dlg.items_info_mcwel.en_elas`i'.setvalue  "`el`i''""'  _n; 
	    file write myfile `".mcwel_dlg.items_info_mcwel.cb_st`i'.setvalue  "`st`i''""'  _n; 
		file write myfile `".mcwel_dlg.items_info_mcwel.en_nf`i'.setvalue  "`nf`i''""'  _n; 
		file write myfile `".mcwel_dlg.items_info_mcwel.en_si`i'.setvalue  "`si`i''""'  _n; 
		file write myfile `".mcwel_dlg.items_info_mcwel.en_sc`i'.setvalue  "`scen`i''""'  _n;
		};
		


local nfile = "$S_FN" ;
/* file write myfile `"cap use `nfile' , replace"'  _n; */
file close myfile;
};

   cap file close myfile;
   tempfile  myfile;
   file open myfile   using "`inisave'.mcw", write append;
 file write myfile `".mcwel_dlg.items_info_mcwel.cb_items.setvalue  `nitems'"'  _n;

 



 local nfile = "$S_FN" ;
 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 file close myfile;







end;

