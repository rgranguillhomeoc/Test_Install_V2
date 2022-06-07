

#delimit ;

capture program drop asdbsave_wquaids;
program define asdbsave_wquaids, rclass sortpreserve;
version 9.2;
	syntax varlist [if] [in] ,					///
		  ANOT(real)						    ///
		[ EXPenditure(varlist min=1 max=1 numeric) 		///
		  PRices(varlist numeric)				///
		  LNPRices(varlist numeric)				///
		  demographics(varlist numeric)				///
		  noQUadratic 						    ///
		  INITial(name) noLOg Level(cilevel) VCE(passthru) 	///
		  IFGNLSIterate(integer 20) /* not documented */	///
		  ITerate(integer 250)      /* not documented */	///
		  HWeight(varname)  ///
		  SNAMES(string)  ///
		  dregres(int 0) ///
		  dec(int 3) ///
		  dislas(int 1) ///
          INISave(string) ///
          xfil(string) ///
		  gmodifier(int 0) ///
		  model(int 1) ///
		  * ///
		   ];


tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

local mylist secp pr;

   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.wquaids" ;
   file open myfile   using "`inisave'.wquaids", write replace ;
   if ("`inisave'"~="")  file write myfile `".wquaids_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   file write myfile `".wquaids_dlg.main.name_items.setvalue "`varlist'""' _n;
   
    if ("`snames'"~="")  file write myfile `".wquaids_dlg.main.name_snames.setvalue "`snames'""' _n;
    if ("`hhsize'"~="")  file write myfile  `".wquaids_dlg.main.vn_hhsize.setvalue "`hhsize'""' _n;
    if ("`expenditure'"~="")   file write myfile  `".wquaids_dlg.main.vn_hhexp.setvalue "`expenditure'""' _n;
	if ("`hweight'"~="") file write myfile  `".wquaids_dlg.main.vn_hhwe.setvalue  "`hweight'""' _n;
	/*if ("`hgroup'"~="")  file write myfile  `".wquaids_dlg.resop.vn_dec.setvalue "`hgroup'""' _n; */
	if ("`demographics'"~="")      file write myfile  `".wquaids_dlg.main.vl_inddemo.setvalue  "`demographics'""' _n;
	if ("`prices'"~="")           file write myfile  `".wquaids_dlg.main.name_prices.setvalue  "`prices'""' _n;
	if ("`dregres'"=="1")         file write myfile `".wquaids_dlg.resop.ck_dregres.seton "' _n; 
	if ("`model'"  =="2")         file write myfile `".wquaids_dlg.main.cb_model.setvalue 2 "' _n; 
	if ("`anot '"~="")            file write myfile `".wquaids_dlg.main.ed_al0.setvalue "`anot'""' _n;
    
   
   if ("`xfil'"~="") {;
   file write myfile `".wquaids_dlg.resop.eldecfile.setvalue "`xfil'""' _n;
   };
   
  if ("`dec'"~="")             file write myfile `".wquaids_dlg.resop.sp_dec.setvalue "`dec'""' _n;
  if ("`dislas'"=="1")         file write myfile `".sr_easi_dlg.resop.ck_dislas.seton "' _n; 

 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 

 file close myfile;







end;

