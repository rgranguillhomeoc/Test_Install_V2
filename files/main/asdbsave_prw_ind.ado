
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

IOMATRIX(string)

IOMODEL(int 1)
TYSHOCK(int 1)
ADSHOCK(int 1)
NADP(int 1)

NSHOCKS(int 1)
SHOCK1(string)
SHOCK2(string)
SHOCK3(string)
SHOCK4(string)
SHOCK5(string)
SHOCK6(string)

INITEMS(int 10)
IITNAMES(varname)
ISNAMES(varname)
MATCH(varname)
IELAS(varname)
IOC(int 0)
ALLIND(int 0)
];


local mylist secp pr;
forvalues i=1/6 {;
if ("`shock`i''"~="") {;
extend_opt_shocks test , `shock`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};

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
   file write myfile `".prcwel_dlg.tb_options_pr_ind.ck_order.seton"' _n;
   file write myfile `".prcwel_dlg.tb_options_pr_ind.ed_aggr.setvalue "`taggregate'""' _n;
   };
   

   
   if ("`tjobs'"~="") {;
   file write myfile `".prcwel_dlg.tb_options_pr_ind.ck_tables.seton"' _n;
   file write myfile `".prcwel_dlg.tb_options_pr_ind.ed_tab.setvalue "`tjobs'""' _n;
   };
   

   
   if ("`xfil'"~="") {;
   file write myfile `".prcwel_dlg.tb_options_pr_ind.ck_excel.seton"' _n;
   file write myfile `".prcwel_dlg.tb_options_pr_ind.fnamex.setvalue "`xfil'""' _n;
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
if "`sn`i''"==""         local sn`i' = "" ;
if "`prc`i''"==""        local prc`i' = "" ;
if "`elas`i''"==""       local elas`i' = "" ;
if ("`it`i''" == "" )    local it`i' = "`it`i''" ;
};


 
   cap file close myfile;
   tempfile  myfile;
   
   file open myfile   using "`inisave'.pr", write append;
 
 if (`oinf'==1)  {;
		forvalues i=1/`nitems' {;
		file write myfile `".prcwel_dlg.items_info_pr_ind.en_sn`i'.setvalue  "`sn`i''""'  _n;  
		file write myfile `".prcwel_dlg.items_info_pr_ind.vn_item`i'.setvalue  "`it`i''""'  _n;   
		file write myfile `".prcwel_dlg.items_info_pr_ind.en_prc`i'.setvalue  "`prc`i''""'  _n; 
		file write myfile `".prcwel_dlg.items_info_pr_ind.en_elas`i'.setvalue  "`elas`i''""'  _n; 
		};
		};
		
file close myfile;
};

 cap file close myfile;
 tempfile  myfile;
 file open myfile   using "`inisave'.pr", write append;
 file write myfile `".prcwel_dlg.items_info_pr_ind.cb_items.setvalue  `nitems'"'  _n;
 file write myfile `".prcwel_dlg.items_info_pr_ind.ed_items.setvalue  `nitems'"'  _n;
 file write myfile `".prcwel_dlg.items_info_pr_ind.cb_ini.setvalue `oinf'""' _n;  
 file write myfile `".prcwel_dlg.items_info_pr_ind.ed_matpel.setvalue  `matpel'"'  _n;
 file write myfile `".prcwel_dlg.items_info_pr_ind.ed_matiel.setvalue  `matiel'"'  _n;
 
 if (`oinf'==2)  {;
 file write myfile `".prcwel_dlg.items_info_pr_ind.var_sn.setvalue  "`snames'""' _n;
 file write myfile `".prcwel_dlg.items_info_pr_ind.var_item.setvalue "`itnames'""' _n;
 file write myfile `".prcwel_dlg.items_info_pr_ind.var_prc.setvalue  "`prc'""' _n;
 file write myfile `".prcwel_dlg.items_info_pr_ind.var_elas.setvalue  "`elas'""' _n;
 };
 
 if `ioc' ==  1  file write myfile `".prcwel_dlg.items_info_pr_indeff.chk_per21.seton""' _n; 
 if `allind' ==  1  file write myfile `".prcwel_dlg.items_info_pr_indeff.allind.seton""' _n; 
 
         file write myfile `".prcwel_dlg.items_info_pr_indeff.cb_ioap.setvalue `iomodel'""' _n; 
         file write myfile `".prcwel_dlg.items_info_pr_indeff.cb_ioap_sh.setvalue `tyshock'""' _n;  
         file write myfile `".prcwel_dlg.items_info_pr_indeff.cb_ioap_ad.setvalue `adshock'""' _n;  
		 file write myfile `".prcwel_dlg.items_info_pr_indeff.ed_np.setvalue `nadp'""' _n; 
		 
 
        if ("`iomatrix'"~="")       file write myfile  `".prcwel_dlg.items_info_pr_indeff.dbiom.setvalue "`iomatrix'""' _n;
        if ("`match'"~="")          file write myfile  `".prcwel_dlg.items_info_pr_indeff.var_ms.setvalue "`match'""' _n;
 		                            file write myfile  `".prcwel_dlg.items_info_pr_indeff.cb_nshocks.setvalue  `nshocks'"'  _n;
	    forvalues i=1/`nshocks' {;
		file write myfile `".prcwel_dlg.items_info_pr_indeff.ed_secp`i'.setvalue  "`secp`i''""'  _n;
		file write myfile `".prcwel_dlg.items_info_pr_indeff.ed_pr`i'.setvalue    "`pr`i''""'    _n;  
		};

        file write myfile  `".prcwel_dlg.items_info_pr_indeff.ed_items.setvalue  `initems'"'  _n;
		file write myfile  `".prcwel_dlg.items_info_pr_indeff.var_sn.setvalue  `isnames'"'  _n;
		file write myfile  `".prcwel_dlg.items_info_pr_indeff.var_item.setvalue  `iitnames'"'  _n;
		file write myfile  `".prcwel_dlg.items_info_pr_indeff.var_elas1.setvalue  `ielass'"'  _n;
		file write myfile  `".prcwel_dlg.items_info_pr_indeff.var_ms.setvalue  `match'"'  _n;
 
 
 file close myfile;


end;

