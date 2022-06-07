



#delimit ;



capture program drop asdbsave_wap;
program define asdbsave_wap, rclass sortpreserve;
version 9.2;
syntax varlist (min=1 max=1) [if] [in] [,  
HSize(string)  
PLine(varname)
HGroup(string)
EPSILON(real 0.5)
THETA(real 0)
INISave(string) 
GVIMP(int 0)
CONF(string) 
LEVEL(real 95)
DEC(int 3)
ADSHOCK(int 1)
NADP(int 1)

NITEMS(int 1)
ITNAMES(string)
ITVNAMES(string)
MATCH(string)
IOMATRIX(string)

SECNAMES(string)

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
   cap erase "`inisave'.wap" ;
   file open myfile   using "`inisave'.wap", write replace ;
   if ("`inisave'"~="")  file write myfile `".wapwel_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   file write myfile `".wapwel_dlg.main.vn_pcexp.setvalue "`1'""' _n;
   file write myfile `".wapwel_dlg.main.vn_hhs.setvalue "`hsize'""' _n;
   file write myfile `".wapwel_dlg.main.vn_pl1.setvalue "`pline'""' _n;
   file write myfile `".wapwel_dlg.main.vn_hhg.setvalue "`hgroup'""' _n;
   
   file write myfile `".wapwel_dlg.items_info_ind.ed_items.setvalue "`nitems'""' _n;
   file write myfile `".wapwel_dlg.items_info_ind.var_sn.setvalue "`itnames'""' _n;
   file write myfile `".wapwel_dlg.items_info_ind.var_secsn.setvalue "`secnames'""' _n;
   file write myfile `".wapwel_dlg.items_info_ind.var_item.setvalue "`itvnames'""' _n;
   file write myfile `".wapwel_dlg.items_info_ind.var_ms.setvalue "`match'""' _n;
   file write myfile `".wapwel_dlg.items_info_ind.dbiom.setvalue "`iomatrix'""' _n;
   
   
   file write myfile `".wapwel_dlg.main.ed_epsilon.setvalue "`epsilon'""' _n; 
   file write myfile `".wapwel_dlg.main.ed_theta.setvalue "`theta'""' _n; 
   
   file write myfile `".wapwel_dlg.main.cb_ioap_ad.setvalue "`adshock'""' _n;
    
   if ("`folgr'"~="")  {;
   file write myfile `".wapwel_dlg.gr_options_wap.ck_folgr.seton"' _n;
   file write myfile `".wapwel_dlg.gr_options_wap.ed_folgr.setvalue "`folgr'""' _n;
   };

   
   if ("`tjobs'"~="") {;
   file write myfile `".wapwel_dlg.tb_options_wap.ck_tables.seton"' _n;
   file write myfile `".wapwel_dlg.tb_options_wap.ed_tab.setvalue "`tjobs'""' _n;
   };
   
   if ("`gjobs'"~="") {;
   file write myfile `".wapwel_dlg.gr_options_wap.ck_graphs.seton"' _n;
   file write myfile `".wapwel_dlg.gr_options_wap.ed_gra.setvalue "`gjobs'""' _n;
   };
   
   if ("`xfil'"~="") {;
   file write myfile `".wapwel_dlg.tb_options_wap.ck_excel.seton"' _n;
   file write myfile `".wapwel_dlg.tb_options_wap.fnamex.setvalue "`xfil'""' _n;
   };
   
  if (`gvimp'==1)     file write myfile `".wapwel_dlg.main.chk_gvimp.seton "' _n; 
   

   forvalues i=1/2 {;
   if ("`min`i''"~="")  file write myfile `".wapwel_dlg.gr_options_wap.en_min`i'.setvalue "`min`i''""' _n;
   if ("`max`i''"~="")  file write myfile `".wapwel_dlg.gr_options_wap.en_max`i'.setvalue "`max`i''""' _n;
   if ("`ogr`i''"~="")  file write myfile `".wapwel_dlg.gr_options_wap.en_opt`i'.setvalue `"`ogr`i''"' "' _n;
   };
   
   file close myfile;  
   
  
  
  

  
 


   cap file close myfile;
   tempfile  myfile;
   file open myfile   using "`inisave'.wap", write append;


 
 local nfile = "$S_FN" ;
 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 file close myfile;







end;

