
#delimit ;

capture program drop asdbsave_prw_ind;
program define asdbsave_prw_ind, rclass sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   
HSize(varname) 
PLINE(varname)
ITNAMES(varname)
SNAMES(varname)
PRC(varname)
ELAS(varname)
OINF(int 1)
HGroup(varname) 
NITEMS(int 1)
XFIL(string)
LAN(string)
TAGGRegate(string)
MEAS(int 1)
MODEL(int 1)
SUBS(real 0.6)
MATPEL(string)
MATIEL(string)
SOTM(int 1)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
TJOBS(string)
GVIMP(int 0) 
GTITLE(string)
IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)
];

tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    
   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.pr" ;
   file open myfile   using "`inisave'.pr", write replace ;
   file write myfile `".prcwel_dlg.main.vn_pcexp.setvalue "`1'""' _n;
   file write myfile `".prcwel_dlg.main.vn_hhs.setvalue "`hsize'""' _n;
   file write myfile `".prcwel_dlg.main.vn_pl1.setvalue "`pline'""' _n;
   file write myfile `".prcwel_dlg.main.cb_meas.setvalue "`meas'""' _n; 
   file write myfile `".prcwel_dlg.main.cb_model.setvalue "`model'""' _n;
   file write myfile `".prcwel_dlg.main.cb_stm.setvalue "`sotm'""' _n;
   file write myfile `".prcwel_dlg.main.ed_subs.setvalue "`subs'""' _n; 
   
   file write myfile `".prcwel_dlg.main.ed_epsilon.setvalue "`epsilon'""' _n; 
   file write myfile `".prcwel_dlg.main.ed_theta.setvalue "`theta'""' _n; 



   if ("`inisave'"~="")  file write myfile `".prcwel_dlg.main.dbsamex.setvalue "`inisave'""' _n;
 
   file write myfile `".prcwel_dlg.main.vn_hhg.setvalue "`hgroup'""' _n;
   
   if ("`taggregate'"~="") {;
   file write myfile `".prcwel_dlg.tb_options_pr.ck_order.seton"' _n;
   file write myfile `".prcwel_dlg.tb_options_pr.ed_aggr.setvalue "`taggregate'""' _n;
   };
   

   
   if ("`tjobs'"~="") {;
   file write myfile `".prcwel_dlg.tb_options_pr.ck_tables.seton"' _n;
   file write myfile `".prcwel_dlg.tb_options_pr.ed_tab.setvalue "`tjobs'""' _n;
   };
   

   
   if ("`xfil'"~="") {;
   file write myfile `".prcwel_dlg.tb_options_pr.ck_excel.seton"' _n;
   file write myfile `".prcwel_dlg.tb_options_pr.fnamex.setvalue "`xfil'""' _n;
   };


   file close myfile;  
   
  
if (`oinf'==1) {;
local mylist sn it prc elas;
forvalues i=1/`nitems' {;
extend_opt_item_pr test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};

forvalues i=1/`nitems' {;
if "`sn`i''"==""        local sn`i' = "" ;
if "`prc`i''"==""       local prc`i' = "" ;
if "`elas`i''"==""       local elas`i' = "" ;
if ("`it`i''" == "" )   local it`i' = "`it`i''" ;
};


 
   cap file close myfile;
   tempfile  myfile;
   
   file open myfile   using "`inisave'.pr", write append;
 
 if (`oinf'==1)  {;
		forvalues i=1/`nitems' {;
		file write myfile `".prcwel_dlg.items_info_pr.en_sn`i'.setvalue  "`sn`i''""'  _n;  
		file write myfile `".prcwel_dlg.items_info_pr.vn_item`i'.setvalue  "`it`i''""'  _n;   
		file write myfile `".prcwel_dlg.items_info_pr.en_prc`i'.setvalue  "`prc`i''""'  _n; 
		file write myfile `".prcwel_dlg.items_info_pr.en_elas`i'.setvalue  "`elas`i''""'  _n; 
		};
		};
		
file close myfile;
};

 cap file close myfile;
 tempfile  myfile;
 file open myfile   using "`inisave'.pr", write append;
 file write myfile `".prcwel_dlg.items_info_pr.cb_items.setvalue  `nitems'"'  _n;
 file write myfile `".prcwel_dlg.items_info_pr.ed_items.setvalue  `nitems'"'  _n;
 file write myfile `".prcwel_dlg.items_info_pr.cb_ini.setvalue `oinf'""' _n;  
 file write myfile `".prcwel_dlg.items_info_pr.ed_matpel.setvalue  `matpel'"'  _n;
 file write myfile `".prcwel_dlg.items_info_pr.ed_matiel.setvalue  `matiel'"'  _n;
 if (`oinf'==2)  {;
 file write myfile `".prcwel_dlg.items_info_pr.var_sn.setvalue  "`snames'""' _n;
 file write myfile `".prcwel_dlg.items_info_pr.var_item.setvalue "`itnames'""' _n;
 file write myfile `".prcwel_dlg.items_info_pr.var_prc.setvalue  "`prc'""' _n;
 file write myfile `".prcwel_dlg.items_info_pr.var_elas.setvalue  "`elas'""' _n;
 };
 
 file close myfile;


end;

