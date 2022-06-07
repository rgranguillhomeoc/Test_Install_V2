
*  ----------------------------------------------------------------------------
*  1. Main program                                                             
*  ----------------------------------------------------------------------------
cap program drop welcom_examples
program welcom_examples
version 9.2
args EXAMPLE
set more off
`EXAMPLE'
end



cap program drop ex_mc_01
program ex_mc_01
#delimit ; 
sysuse Mexico_2014.dta, replace; 
mcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(mcwel_example_01) nitems(1) 
it1( sn(Combustible) vn(pcexp_comb) el(elas1) st(3) si(0.4231) ) 
move(-1) epsilon(.5) 
opgr2( min(0) max(0.9) )
opgr3( min(0) max(0.9) ) 
xfil(myexample1)  folgr(Graphs)
;
#delimit cr
end


cap program drop ex_mc_db_01
program ex_mc_db_01
sysuse Mexico_2014.dta, replace
discard
db mcwel
.mcwel_dlg.main.dbsamex.setvalue "mcwel_example_1"
.mcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.mcwel_dlg.main.vn_hhs.setvalue "hhsize"
.mcwel_dlg.main.vn_pl1.setvalue "pline"
.mcwel_dlg.main.vn_hhg.setvalue ""
.mcwel_dlg.main.cb_meas.setvalue "1"
.mcwel_dlg.main.cb_model.setvalue "1"
.mcwel_dlg.main.ed_subs.setvalue ".6"
.mcwel_dlg.main.cb_move.setvalue "-1"
.mcwel_dlg.items_info_mcwel.ed_mpart.setvalue "0"
.mcwel_dlg.main.ed_epsilon.setvalue ".5"
.mcwel_dlg.main.ed_theta.setvalue "0"
.mcwel_dlg.gr_options_mc.ck_folgr.seton
.mcwel_dlg.gr_options_mc.ed_folgr.setvalue "Graphs"
.mcwel_dlg.tb_options_mc.ck_excel.seton
.mcwel_dlg.tb_options_mc.fnamex.setvalue "myexample"
.mcwel_dlg.main.chk_gvimp.seton 
.mcwel_dlg.gr_options_mc.en_min2.setvalue "0"
.mcwel_dlg.gr_options_mc.en_max2.setvalue "0.9"
.mcwel_dlg.gr_options_mc.en_min3.setvalue "0"
.mcwel_dlg.gr_options_mc.en_max3.setvalue "0.9"
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.cb_items.setvalue  1
#delimit cr
end



*  ----------------------------------------------------------------------------
*  2- MCWEL                                                          
*  ----------------------------------------------------------------------------
cap program drop ex_mc_02
program ex_mc_02
#delimit ; 
sysuse Mexico_2014.dta, replace; ; 
mcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(mcwel_example_02) nitems(3) 
it1( sn(Combustible) vn(pcexp_comb) el(elas1) st(3) si(0.4231) ) 
it2( sn(Communication) vn(pcexp_comu) el(elas2) st(2) nf(8) ) 
it3( sn(Cereals) vn(pcexp_cereal) el(elas3) st(3) si(0.3471) ) 
mpart(6) move(-1) epsilon(.5) 
opgr2( min(0) max(0.9) )
opgr3( min(0) max(0.9) ) 
xfil(myexample1)  folgr(Graphs)
;
#delimit cr
end


cap program drop ex_mc_db_02
program ex_mc_db_02
sysuse Mexico_2014.dta, replace
discard
db mcwel
.mcwel_dlg.main.dbsamex.setvalue "mcwel_example_02"
.mcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.mcwel_dlg.main.vn_hhs.setvalue "hhsize"
.mcwel_dlg.main.vn_pl1.setvalue "pline"
.mcwel_dlg.main.vn_hhg.setvalue ""
.mcwel_dlg.main.cb_meas.setvalue "1"
.mcwel_dlg.main.cb_model.setvalue "1"
.mcwel_dlg.main.ed_subs.setvalue ".6"
.mcwel_dlg.main.cb_move.setvalue "-1"
.mcwel_dlg.items_info_mcwel.ed_mpart.setvalue "6"
.mcwel_dlg.main.ed_epsilon.setvalue ".5"
.mcwel_dlg.main.ed_theta.setvalue "0"
.mcwel_dlg.gr_options_mc.ck_folgr.seton
.mcwel_dlg.gr_options_mc.ed_folgr.setvalue "Graphs"
.mcwel_dlg.tb_options_mc.ck_excel.seton
.mcwel_dlg.tb_options_mc.fnamex.setvalue "myexample"
.mcwel_dlg.main.chk_gvimp.seton 
.mcwel_dlg.gr_options_mc.en_min2.setvalue "0"
.mcwel_dlg.gr_options_mc.en_max2.setvalue "0.9"
.mcwel_dlg.gr_options_mc.en_min3.setvalue "0"
.mcwel_dlg.gr_options_mc.en_max3.setvalue "0.9"
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.en_sn2.setvalue  ""
.mcwel_dlg.items_info_mcwel.vn_item2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_elas2.setvalue  "0"
.mcwel_dlg.items_info_mcwel.cb_st2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_nf2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sn3.setvalue  ""
.mcwel_dlg.items_info_mcwel.vn_item3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_elas3.setvalue  "0"
.mcwel_dlg.items_info_mcwel.cb_st3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_nf3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.en_sn2.setvalue  "Communication"
.mcwel_dlg.items_info_mcwel.vn_item2.setvalue  "pcexp_comu"
.mcwel_dlg.items_info_mcwel.en_elas2.setvalue  "elas2"
.mcwel_dlg.items_info_mcwel.cb_st2.setvalue  "2"
.mcwel_dlg.items_info_mcwel.en_nf2.setvalue  "8"
.mcwel_dlg.items_info_mcwel.en_si2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sn3.setvalue  ""
.mcwel_dlg.items_info_mcwel.vn_item3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_elas3.setvalue  "0"
.mcwel_dlg.items_info_mcwel.cb_st3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_nf3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.en_sn2.setvalue  "Communication"
.mcwel_dlg.items_info_mcwel.vn_item2.setvalue  "pcexp_comu"
.mcwel_dlg.items_info_mcwel.en_elas2.setvalue  "elas2"
.mcwel_dlg.items_info_mcwel.cb_st2.setvalue  "2"
.mcwel_dlg.items_info_mcwel.en_nf2.setvalue  "8"
.mcwel_dlg.items_info_mcwel.en_si2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sn3.setvalue  "Cereals"
.mcwel_dlg.items_info_mcwel.vn_item3.setvalue  "pcexp_cereal"
.mcwel_dlg.items_info_mcwel.en_elas3.setvalue  "elas3"
.mcwel_dlg.items_info_mcwel.cb_st3.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si3.setvalue  "0.3471"
.mcwel_dlg.items_info_mcwel.cb_items.setvalue  3
#delimit cr
end




*  ----------------------------------------------------------------------------
*  3- MCWEL                                                          
*  ----------------------------------------------------------------------------
cap program drop ex_mc_03
program ex_mc_03
#delimit ; 
sysuse Mexico_2014.dta, replace; 
mcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(mcwel_example_03) nitems(3)  gscen(1)
it1( sn(Combustible) vn(pcexp_comb)   el(elas1) st(3) si(0.4231) scen(0.3 0.2) ) 
it2( sn(Communication) vn(pcexp_comu) el(elas2) st(2) nf(8)      scen(12  30)  ) 
it3( sn(Cereals) vn(pcexp_cereal)     el(elas3) st(3) si(0.3471) scen(0.2 0.1) ) 
mpart(2) move(-1) epsilon(.5) 
opgr2( min(0) max(0.9) )
opgr3( min(0) max(0.9) ) 
xfil(myexample1)  folgr(Graphs)
;
#delimit cr
end


cap program drop ex_mc_db_03
program ex_mc_db_03
sysuse Mexico_2014.dta, replace
discard
db mcwel
.mcwel_dlg.main.dbsamex.setvalue "mcwel_example_03"
.mcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.mcwel_dlg.main.vn_hhs.setvalue "hhsize"
.mcwel_dlg.main.vn_pl1.setvalue "pline"
.mcwel_dlg.main.vn_hhg.setvalue ""
.mcwel_dlg.main.cb_meas.setvalue "1"
.mcwel_dlg.main.cb_model.setvalue "1"
.mcwel_dlg.main.ed_subs.setvalue ".6"
.mcwel_dlg.main.cb_move.setvalue "-1"
.mcwel_dlg..items_info_mcwel.ed_mpart.setvalue "2"
.mcwel_dlg.main.ed_epsilon.setvalue ".5"
.mcwel_dlg.main.ed_theta.setvalue "0"
.mcwel_dlg.gr_options_mc.ck_folgr.seton
.mcwel_dlg.gr_options_mc.ed_folgr.setvalue "Graphs"
.mcwel_dlg.tb_options_mc.ck_excel.seton
.mcwel_dlg.tb_options_mc.fnamex.setvalue "myexample1"
.mcwel_dlg.main.chk_gvimp.seton 
.mcwel_dlg.gr_options_mc.en_min2.setvalue "0"
.mcwel_dlg.gr_options_mc.en_max2.setvalue "0.9"
.mcwel_dlg.gr_options_mc.en_min3.setvalue "0"
.mcwel_dlg.gr_options_mc.en_max3.setvalue "0.9"
.mcwel_dlg.items_info_mcwel.def_step.seton
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.en_sc1.setvalue  "0.3 0.2"
.mcwel_dlg.items_info_mcwel.en_sn2.setvalue  ""
.mcwel_dlg.items_info_mcwel.vn_item2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_elas2.setvalue  "0"
.mcwel_dlg.items_info_mcwel.cb_st2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_nf2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sc2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sn3.setvalue  ""
.mcwel_dlg.items_info_mcwel.vn_item3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_elas3.setvalue  "0"
.mcwel_dlg.items_info_mcwel.cb_st3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_nf3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sc3.setvalue  ""
.mcwel_dlg.items_info_mcwel.def_step.seton
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.en_sc1.setvalue  "0.3 0.2"
.mcwel_dlg.items_info_mcwel.en_sn2.setvalue  "Communication"
.mcwel_dlg.items_info_mcwel.vn_item2.setvalue  "pcexp_comu"
.mcwel_dlg.items_info_mcwel.en_elas2.setvalue  "elas2"
.mcwel_dlg.items_info_mcwel.cb_st2.setvalue  "2"
.mcwel_dlg.items_info_mcwel.en_nf2.setvalue  "8"
.mcwel_dlg.items_info_mcwel.en_si2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sc2.setvalue  "12 30"
.mcwel_dlg.items_info_mcwel.en_sn3.setvalue  ""
.mcwel_dlg.items_info_mcwel.vn_item3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_elas3.setvalue  "0"
.mcwel_dlg.items_info_mcwel.cb_st3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_nf3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sc3.setvalue  ""
.mcwel_dlg.items_info_mcwel.def_step.seton
.mcwel_dlg.items_info_mcwel.en_sn1.setvalue  "Combustible"
.mcwel_dlg.items_info_mcwel.vn_item1.setvalue  "pcexp_comb"
.mcwel_dlg.items_info_mcwel.en_elas1.setvalue  "elas1"
.mcwel_dlg.items_info_mcwel.cb_st1.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf1.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si1.setvalue  "0.4231"
.mcwel_dlg.items_info_mcwel.en_sc1.setvalue  "0.3 0.2"
.mcwel_dlg.items_info_mcwel.en_sn2.setvalue  "Communication"
.mcwel_dlg.items_info_mcwel.vn_item2.setvalue  "pcexp_comu"
.mcwel_dlg.items_info_mcwel.en_elas2.setvalue  "elas2"
.mcwel_dlg.items_info_mcwel.cb_st2.setvalue  "2"
.mcwel_dlg.items_info_mcwel.en_nf2.setvalue  "8"
.mcwel_dlg.items_info_mcwel.en_si2.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_sc2.setvalue  "12 30"
.mcwel_dlg.items_info_mcwel.en_sn3.setvalue  "Cereals"
.mcwel_dlg.items_info_mcwel.vn_item3.setvalue  "pcexp_cereal"
.mcwel_dlg.items_info_mcwel.en_elas3.setvalue  "elas3"
.mcwel_dlg.items_info_mcwel.cb_st3.setvalue  "3"
.mcwel_dlg.items_info_mcwel.en_nf3.setvalue  ""
.mcwel_dlg.items_info_mcwel.en_si3.setvalue  "0.3471"
.mcwel_dlg.items_info_mcwel.en_sc3.setvalue  "0.2 0.1"
.mcwel_dlg.items_info_mcwel.cb_items.setvalue  3
#delimit cr
end




*  ----------------------------------------------------------------------------
*  1- DUVM                                                          
*  ----------------------------------------------------------------------------

cap program drop ex_duvm_01
program ex_duvm_01
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other, 
hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex1_duvm_db)  indcat(sex educ )  indcon(age)   xfil(myfile) 
 ;
#delimit cr
end


cap program drop ex_duvm_02
program ex_duvm_02
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other, 
hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex2_duvm_db)  indcat(sex educ )  indcon(age)   xfil(myfile)
boot(50)
 ;
#delimit cr
end

cap program drop ex_duvm_03
program ex_duvm_03
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other, 
hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex3_duvm_db)  indcat(sex educ )  indcon(age)   xfil(myfile) 
hgroup(decile)
 ;
#delimit cr              
end

cap program drop ex_duvm_db_01
program ex_duvm_db_01
sysuse Mexico_2014_Cereals.dta , replace
discard
db duvm
.duvm_dlg.main.dbsamex.setvalue "ex1_duvm_db"
.duvm_dlg.main.name_items.setvalue "corn wheat rice other"
.duvm_dlg.main.vn_hhsize.setvalue "hhsize"
.duvm_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.duvm_dlg.main.vn_hhwe.setvalue  "sweight"
.duvm_dlg.main.vl_indcat.setvalue  "sex educ "
.duvm_dlg.main.vl_indcon.setvalue  "age"
.duvm_dlg.main.vn_cluster.setvalue "psu"
.duvm_dlg.main.vn_region.setvalue "rururb"
.duvm_dlg.resop.sp_dec.setvalue "3"
.duvm_dlg.resop.n_boot.setvalue "0"
#delimit cr
end


cap program drop ex_duvm_db_02
program ex_duvm_db_02
sysuse Mexico_2014_Cereals.dta , replace
discard
db duvm
.duvm_dlg.main.dbsamex.setvalue "ex2_duvm_db"
.duvm_dlg.main.name_items.setvalue "corn wheat rice other"
.duvm_dlg.main.vn_hhsize.setvalue "hhsize"
.duvm_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.duvm_dlg.main.vn_hhwe.setvalue  "sweight"
.duvm_dlg.main.vl_indcat.setvalue  "sex educ "
.duvm_dlg.main.vl_indcon.setvalue  "age"
.duvm_dlg.main.vn_cluster.setvalue "psu"
.duvm_dlg.main.vn_region.setvalue "rururb"
.duvm_dlg.resop.sp_dec.setvalue "3"
.duvm_dlg.resop.n_boot.setvalue "50"
#delimit cr
end


cap program drop ex_duvm_db_03
program ex_duvm_db_03
sysuse Mexico_2014_Cereals.dta , replace
discard
db duvm
.duvm_dlg.main.dbsamex.setvalue "ex3_duvm_db"
.duvm_dlg.main.name_items.setvalue "corn wheat rice other"
.duvm_dlg.main.vn_hhsize.setvalue "hhsize"
.duvm_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.duvm_dlg.main.vn_hhwe.setvalue  "sweight"
.duvm_dlg.resop.vn_dec.setvalue "decile"
.duvm_dlg.main.vl_indcat.setvalue  "sex educ "
.duvm_dlg.main.vl_indcon.setvalue  "age"
.duvm_dlg.main.vn_cluster.setvalue "psu"
.duvm_dlg.main.vn_region.setvalue "rururb"
.duvm_dlg.resop.sp_dec.setvalue "3"
.duvm_dlg.resop.n_boot.setvalue "0"
#delimit cr
end



*  ----------------------------------------------------------------------------
*  2- WQUAIDS                                                         
*  ----------------------------------------------------------------------------

cap program drop ex_wquaids_01
program ex_wquaids_01
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace;
wquaids wcorn wwheat wrice wother wcomp, anot(9.5) 
prices(pcorn pwheat price pother pcomp) 
snames(Corn Wheat Rice Other_cereal Rest) 
expend(hh_current_inc) hweight(sweight) 
model(1) inisave(myproj.wquaids) 
dregres(0) xfil(myfil) dislas(0);
#delimit cr
end

cap program drop ex_wquaids_02
program ex_wquaids_02
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace; 
set seed 1234;
bsample 2000;
wquaids wcorn wwheat wrice wother wcomp, anot(9.5) 
prices(pcorn pwheat price pother pcomp) 
snames(Corn Wheat Rice Other_cereal Rest) 
expend(hh_current_inc) hweight(sweight) 
model(1) inisave(myproj.wquaids) 
demographics(age isMale) dregres(1) xfil(myfil) dislas(0);
#delimit cr
end

cap program drop ex_wquaids_db_01
program ex_wquaids_db_01
sysuse Mexico_2014_Cereals.dta , replace
discard
db wquaids
.wquaids_dlg.main.dbsamex.setvalue "ex1_quaids_db"
.wquaids_dlg.main.name_items.setvalue "wcorn wwheat wrice wother wcomp"
.wquaids_dlg.main.name_snames.setvalue "Corn Wheat Rice Other_cereal Rest"
.wquaids_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.wquaids_dlg.main.vn_hhwe.setvalue  "sweight"
.wquaids_dlg.main.name_prices.setvalue  "pcorn pwheat price pother pcomp"
.wquaids_dlg.main.ed_al0.setvalue "9.5"
.wquaids_dlg.resop.eldecfile.setvalue "myfil"
.wquaids_dlg.resop.sp_dec.setvalue "3"
#delimit cr
end


cap program drop ex_wquaids_db_02
program ex_wquaids_db_02
sysuse Mexico_2014_Cereals.dta , replace
discard
db wquaids
.wquaids_dlg.main.dbsamex.setvalue "ex2_quaids_db"
.wquaids_dlg.main.name_items.setvalue "wcorn wwheat wrice wother wcomp"
.wquaids_dlg.main.name_snames.setvalue "Corn Wheat Rice Other_cereal Rest"
.wquaids_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.wquaids_dlg.main.vn_hhwe.setvalue  "sweight"
.wquaids_dlg.main.vl_inddemo.setvalue  "age isMale"
.wquaids_dlg.main.name_prices.setvalue  "pcorn pwheat price pother pcomp"
.wquaids_dlg.resop.ck_dregres.seton 
.wquaids_dlg.main.ed_al0.setvalue "9.5"
.wquaids_dlg.resop.eldecfile.setvalue "myfil"
.wquaids_dlg.resop.sp_dec.setvalue "3"
#delimit cr
end


*  ----------------------------------------------------------------------------
*  3- EASI                                                         
*  ----------------------------------------------------------------------------


cap program drop ex_easi_01
program ex_easi_01
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace;
set seed 1234;
bsample 4000;
 sr_easi wcorn wwheat wrice wother wcomp, 
 prices(pcorn pwheat price pother pcomp) 
 snames(corn wheat rice other comp) 
 expenditure(hh_current_inc) inisave(myproj) 
 demographics(age isMale educa2 educa3 educa4 educa5 educa6 educa7) 
 dec(4) dregres(1) dislas(0) 
 xfil(myres) 
 power(3) 
 inpy(1) inpz(0) inzy(0)
;
#delimit cr
end

cap program drop ex_easi_02
program ex_easi_02
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace;
set seed 1234;
bsample 4000;
 sr_easi wcorn wwheat wrice wother wcomp, 
 prices(pcorn pwheat price pother pcomp) 
 snames(corn wheat rice other comp) 
 expenditure(hh_current_inc) inisave(myproj) 
 demographics(age isMale educa2 educa3 educa4 educa5 educa6 educa7) 
 dec(4) dregres(1) dislas(0) 
 xfil(myres) 
 power(5) 
 inpy(1) inpz(1) inzy(0);
#delimit cr
end

cap program drop ex_easi_db_01
program ex_easi_db_01
sysuse Mexico_2014_Cereals.dta, replace
set seed 1234
bsample 4000
discard
db sr_easi
.sr_easi_dlg.main.dbsamex.setvalue "ex1_easi_db"
.sr_easi_dlg.main.name_items.setvalue "wcorn wwheat wrice wother wcomp"
.sr_easi_dlg.main.name_snames.setvalue "corn wheat rice other comp"
.sr_easi_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.sr_easi_dlg.main.vl_inddemo.setvalue  "age isMale educa2 educa3 educa4 educa5 educa6 educa7"
.sr_easi_dlg.main.name_prices.setvalue  "pcorn pwheat price pother pcomp"
.sr_easi_dlg.main.sp_pow.setvalue  3
.sr_easi_dlg.resop.ck_dregres.seton 
.sr_easi_dlg.main.ck_inpy.seton 
.sr_easi_dlg.resop.sp_dec.setvalue "4"
.sr_easi_dlg.resop.eldecfile.setvalue "myres"
#delimit cr
end


cap program drop ex_easi_db_02
program ex_easi_db_02
sysuse Mexico_2014_Cereals.dta , replace
set seed 1234
bsample 4000
discard
db sr_easi
.sr_easi_dlg.main.dbsamex.setvalue "ex2_easi_db"
.sr_easi_dlg.main.name_items.setvalue "wcorn wwheat wrice wother wcomp"
.sr_easi_dlg.main.name_snames.setvalue "corn wheat rice other comp"
.sr_easi_dlg.main.vn_hhexp.setvalue "hh_current_inc"
.sr_easi_dlg.main.vl_inddemo.setvalue  "age isMale educa2 educa3 educa4 educa5 educa6 educa7"
.sr_easi_dlg.main.name_prices.setvalue  "pcorn pwheat price pother pcomp"
.sr_easi_dlg.main.sp_pow.setvalue  5
.sr_easi_dlg.resop.ck_dregres.seton 
.sr_easi_dlg.main.ck_inpy.seton 
.sr_easi_dlg.main.ck_inpz.seton 
.sr_easi_dlg.resop.sp_dec.setvalue "4"
.sr_easi_dlg.resop.eldecfile.setvalue "myres"
#delimit cr
end



cap program drop ex_sids_01
program ex_sids_01
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace;
sids hh_q_corn pcorn hh_current_inc, hgroup(quintile)  indcon(age) ;
#delimit cr
end

cap program drop ex_sids_02
program ex_sids_02
#delimit ; 
sysuse Mexico_2014_Cereals.dta , replace;
sids hh_q_corn pcorn hh_current_inc, hgroup(sex) incpar(decile) indcon(age) incint(1)  xfil(myres)  dgra(1) ;
#delimit cr
end

cap program drop ex_lmc_01
program ex_lmc_01
#delimit ; 
sysuse sectors.dta, replace;
save sectors.dta, replace;
sysuse incomes.dta, replace;
save incomes.dta, replace;
sysuse Mexico_2014.dta , replace; 
lmcwel pc_income, hhid(folioviv foliohog) hsize(hhsize) pline(pline) 
inisave(myexp) 
incomes(incomes.dta) 
sectors(sectors.dta) 
epsilon(.5) xfil(myexcel) folgr(mygraphs)
;
#delimit cr
end




cap program drop ex_lmc_db_01
program ex_lmc_db_01
sysuse sectors.dta, replace
save sectors.dta, replace
sysuse incomes.dta, replace
save incomes.dta, replace
sysuse Mexico_2014.dta, replace
discard
db lmcwel
.lmcwel_dlg.main.dbsamex.setvalue "myexp"
.lmcwel_dlg.labor_info_lmcwel.sectors.setvalue "sectors.dta"
.lmcwel_dlg.labor_info_lmcwel.incomes.setvalue "incomes.dta"
.lmcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.lmcwel_dlg.main.vl_hhid.setvalue "folioviv foliohog"
.lmcwel_dlg.main.vn_hhs.setvalue "hhsize"
.lmcwel_dlg.main.vn_pl1.setvalue "pline"
.lmcwel_dlg.main.vn_hhg.setvalue ""
.lmcwel_dlg.main.ed_epsilon.setvalue ".5"
.lmcwel_dlg.main.ed_theta.setvalue "0"
.lmcwel_dlg.gr_options_lmc.ck_folgr.seton
.lmcwel_dlg.gr_options_lmc.ed_folgr.setvalue "mygraphs"
.lmcwel_dlg.tb_options_lmc.ck_excel.seton
.lmcwel_dlg.tb_options_lmc.fnamex.setvalue "myexcel"
#delimit cr
end



cap program drop ex_wap_01
program ex_wap_01
#delimit ; 
sysuse SAM_MEX_2003.dta, replace;
save SAM_MEX_2003.dta, replace;
sysuse Mexico_2014_WAP.dta , replace; 
wapwel pc_income, hsize(hhsize) pline(pline) inisave(myexp) nitems(11) itnames(itnames) 
itvnames(vnnames) match(match_sec) iomatrix(SAM_MEX_2003.dta) 
secnames(secnames) opgr1( max(0.95) ) xfil(myfile)
;
#delimit cr
end




cap program drop ex_wap_db_01
program ex_wap_db_01
sysuse SAM_MEX_2003.dta, replace
save   SAM_MEX_2003.dta, replace
sysuse Mexico_2014_WAP.dta , replace 
discard
db wapwel
.wapwel_dlg.main.dbsamex.setvalue "myexp"
.wapwel_dlg.main.vn_pcexp.setvalue "pc_income"
.wapwel_dlg.main.vn_hhs.setvalue "hhsize"
.wapwel_dlg.main.vn_pl1.setvalue "pline"
.wapwel_dlg.main.vn_hhg.setvalue ""
.wapwel_dlg.items_info_ind.ed_items.setvalue "11"
.wapwel_dlg.items_info_ind.var_sn.setvalue "itnames"
.wapwel_dlg.items_info_ind.var_secsn.setvalue "secnames"
.wapwel_dlg.items_info_ind.var_item.setvalue "vnnames"
.wapwel_dlg.items_info_ind.var_ms.setvalue "match_sec"
.wapwel_dlg.items_info_ind.dbiom.setvalue "SAM_MEX_2003.dta"
.wapwel_dlg.main.ed_epsilon.setvalue ".5"
.wapwel_dlg.main.ed_theta.setvalue "0"
.wapwel_dlg.main.cb_ioap_ad.setvalue "1"
.wapwel_dlg.tb_options_wap.ck_excel.seton
.wapwel_dlg.tb_options_wap.fnamex.setvalue "myfile"
.wapwel_dlg.gr_options_wap.en_max1.setvalue "0.95"
#delimit cr
end




cap program drop ex_mcema_01
program ex_mcema_01
#delimit ; 
sysuse Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(1) grmod1(psu) welfare(pc_income) hsize(hhsize) hgroup(tam_loc) pline(pline)  
indcat(socio educ) indcon(hhsize) pswp(.05) pchange(price_change) ichange(income_change) expshare(eshare) 
 um(1) dec(3) inisave(example1) xfil(myres1)
;
#delimit cr
end


cap program drop ex_mcema_db_01
program ex_mcema_db_01
sysuse Mexico_2014_Cellphones.dta , replace
discard
db mcema
.mcema_dlg.main.dbsamex.setvalue "example1"
.mcema_dlg.main.vn_d_cons.setvalue d_cell
.mcema_dlg.main.vn_d_consc.setvalue pc_exp_cell
.mcema_dlg.main.vn_pr.setvalue 
.mcema_dlg.main.vn_inc.setvalue pc_income
.mcema_dlg.main.vn_hhs.setvalue hhsize
.mcema_dlg.main.vn_hg.setvalue tam_loc
.mcema_dlg.main.vn_pline.setvalue pline
.mcema_dlg.main.vn_incpar.setvalue 
.mcema_dlg.main.vl_indcat.setvalue socio educ
.mcema_dlg.main.vl_indcon.setvalue hhsize
.mcema_dlg.main.fl_pswp.setvalue .05
.mcema_dlg.main.ck_swp.seton
.mcema_dlg.main.com_um.setvalue 1
.mcema_dlg.main.ck_adj.seton
.mcema_dlg.main.vn_share.setvalue eshare
.mcema_dlg.main.cb_moda.setvalue 1 
.mcema_dlg.main.gr_moda1.setvalue psu
.mcema_dlg.main.gr_moda2.setvalue 
.mcema_dlg.main.ed_modaq1.setvalue 20
.mcema_dlg.main.cb_cpri.setvalue 1
.mcema_dlg.main.cb_cons.setvalue 1
.mcema_dlg.main.cb_cinc.setvalue 1
.mcema_dlg.main.ed_oopt.setvalue 
.mcema_dlg.main.vl_indcatc.setvalue 
.mcema_dlg.main.vl_indconc.setvalue 
.mcema_dlg.main.vn_pchange.setvalue price_change
.mcema_dlg.main.vn_ichange.setvalue income_change
.mcema_dlg.main.fl_pswe.setvalue 1
.mcema_dlg.resop.ck_excel.seton
.mcema_dlg.resop.fnamex.setvalue "myres1"
.mcema_dlg.resop.sp_dec.setvalue 3
#delimit cr
end






cap program drop ex_mcema_02
program ex_mcema_02
#delimit ; 
sysuse Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(3) welfare(pc_income) hsize(hhsize) hgroup(tam_loc) 
indcat(socio educ) indcon(hhsize) pswp(.05) pchange(price_change) ichange(income_change) 
expshare(eshare) ewgr(quintile) um(3) dec(3) fex(2) fpr(3) fin(2) cindcat(socio educ) 
cindcon(age) inisave(example2) xfil(myres2) pline(pline) disgr(tam_loc);
#delimit cr
end

cap program drop ex_mcema_db_02
program ex_mcema_db_02
sysuse Mexico_2014_Cellphones.dta , replace
discard
db mcema
.mcema_dlg.main.dbsamex.setvalue "example2"
.mcema_dlg.main.vn_d_cons.setvalue d_cell
.mcema_dlg.main.vn_d_consc.setvalue pc_exp_cell
.mcema_dlg.main.vn_pr.setvalue 
.mcema_dlg.main.vn_inc.setvalue pc_income
.mcema_dlg.main.vn_pline.setvalue pline
.mcema_dlg.main.vn_hhs.setvalue hhsize
.mcema_dlg.main.vn_hg.setvalue tam_loc
.mcema_dlg.main.vn_incpar.setvalue 
.mcema_dlg.main.vl_indcat.setvalue socio educ
.mcema_dlg.main.vl_indcon.setvalue hhsize
.mcema_dlg.resop.var_disgr.setvalue tam_loc
.mcema_dlg.main.fl_pswp.setvalue .05
.mcema_dlg.main.ck_swp.seton
.mcema_dlg.main.com_um.setvalue 3
.mcema_dlg.main.ck_adj.seton
.mcema_dlg.main.vn_share.setvalue eshare
.mcema_dlg.main.cb_moda.setvalue 3  
.mcema_dlg.main.ed_seed.setvalue 123456 
.mcema_dlg.main.ed_modaq1.setvalue 20
.mcema_dlg.main.gr_moda1.setvalue 
.mcema_dlg.main.gr_moda2.setvalue  
.mcema_dlg.main.cb_cpri.setvalue 3
.mcema_dlg.main.cb_cons.setvalue 2
.mcema_dlg.main.cb_cinc.setvalue 2
.mcema_dlg.main.ed_oopt.setvalue 
.mcema_dlg.main.vl_indcatc.setvalue socio educ
.mcema_dlg.main.vl_indconc.setvalue age
.mcema_dlg.main.vn_pchange.setvalue price_change
.mcema_dlg.main.vn_ichange.setvalue income_change
.mcema_dlg.main.fl_pswe.setvalue 1
.mcema_dlg.resop.ck_excel.seton
.mcema_dlg.resop.fnamex.setvalue "myres2"
.mcema_dlg.resop.sp_dec.setvalue 3
#delimit cr
end




cap program drop ex_mcema_03
program ex_mcema_03
#delimit ; 
sysuse Mexico_2014_2018_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(3) grmod1(decile) grmod2(tam_loc) welfare(pc_income) 
hsize(hhsize) hgroup(tam_loc) pline(pline) incpar(quintile) indcat(socio educ) indcon(hhsize) 
pswp(.05) pswe(.05) pchange(pchange) um(5) dec(3) fex(2) fpr(3) fin(2) exnum(1) 
grmac(entity) totentr(new_users) cindcat(sex) cindcon(age) inisave(example3) xfil(myres3)
;
#delimit cr
end

cap program drop ex_mcema_db_03
program ex_mcema_db_03
sysuse Mexico_2014_2018_Cellphones.dta , replace
discard
db mcema
.mcema_dlg.main.dbsamex.setvalue "example3"
.mcema_dlg.main.vn_d_cons.setvalue d_cell
.mcema_dlg.main.vn_d_consc.setvalue pc_exp_cell
.mcema_dlg.main.vn_pr.setvalue 
.mcema_dlg.main.vn_inc.setvalue pc_income
.mcema_dlg.main.vn_hhs.setvalue hhsize
.mcema_dlg.main.vn_hg.setvalue tam_loc
.mcema_dlg.main.vn_pline.setvalue pline
.mcema_dlg.main.vn_incpar.setvalue quintile
.mcema_dlg.main.vl_indcat.setvalue socio educ
.mcema_dlg.main.vl_indcon.setvalue hhsize
.mcema_dlg.resop.var_disgr.setvalue 
.mcema_dlg.main.fl_pswp.setvalue .05
.mcema_dlg.main.ck_swp.seton
.mcema_dlg.main.com_um.setvalue 5
.mcema_dlg.main.vn_share.setvalue 
.mcema_dlg.main.cb_moda.setvalue 3 
.mcema_dlg.main.ed_modaq1.setvalue 20 
.mcema_dlg.main.gr_moda1.setvalue decile
.mcema_dlg.main.gr_moda2.setvalue tam_loc
.mcema_dlg.main.cb_cpri.setvalue 3
.mcema_dlg.main.cb_cons.setvalue 2
.mcema_dlg.main.cb_cinc.setvalue 2
.mcema_dlg.main.ed_oopt.setvalue 
.mcema_dlg.main.vl_indcatc.setvalue sex
.mcema_dlg.main.vl_indconc.setvalue age
.mcema_dlg.main.vn_pchange.setvalue pchange
.mcema_dlg.main.vn_ichange.setvalue 
.mcema_dlg.main.fl_pswe.setvalue .05
.mcema_dlg.main.ck_swe.seton
.mcema_dlg.resop.ck_excel.seton
.mcema_dlg.resop.fnamex.setvalue "myres3"
.mcema_dlg.resop.sp_dec.setvalue 3
.mcema_dlg.main.ck_mac.seton
.mcema_dlg.main.gr_mac.setvalue entity
.mcema_dlg.main.var_tent.setvalue new_users
.mcema_dlg.main.var_tuse.setvalue 
.mcema_dlg.main.eli_mac.setvalue 
#delimit cr
end





cap program drop ex_prc_01
program ex_prc_01
#delimit ; 
//set trace on;
set tracedepth 1;
sysuse Mexico_2014.dta , replace; 
gen prc_Cereals=0.08;
prcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(prcwel_example_1) nitems(1)  
it1( sn(Cereals)       it(pcexp_cereal)  prc(prc_Cereals)  ) 
epsilon(.5)  
xfil(example1)  
;
#delimit cr
end


cap program drop ex_prc_db_01
program ex_prc_db_01
sysuse Mexico_2014.dta , replace
gen prc_Cereals=0.08
discard
db prcwel
.prcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.prcwel_dlg.main.vn_hhs.setvalue "hhsize"
.prcwel_dlg.main.vn_pl1.setvalue "pline"
.prcwel_dlg.main.cb_meas.setvalue "1"
.prcwel_dlg.main.cb_model.setvalue "1"
.prcwel_dlg.main.ed_subs.setvalue ".6"
.prcwel_dlg.main.ed_epsilon.setvalue ".5"
.prcwel_dlg.main.ed_theta.setvalue "0"
.prcwel_dlg.main.dbsamex.setvalue "prcwel_example_01"
.prcwel_dlg.main.vn_hhg.setvalue ""
.prcwel_dlg.tb_options_pr_ind.ck_excel.seton
.prcwel_dlg.tb_options_pr_ind.fnamex.setvalue "example1"
.prcwel_dlg.items_info_pr_ind.en_sn1.setvalue  "Cereals"
.prcwel_dlg.items_info_pr_ind.vn_item1.setvalue  "pcexp_cereal"
.prcwel_dlg.items_info_pr_ind.en_prc1.setvalue  "prc_Cereals"
.prcwel_dlg.items_info_pr_ind.cb_items.setvalue  1
.prcwel_dlg.items_info_pr_ind.ed_items.setvalue  1
.prcwel_dlg.items_info_pr_ind.cb_ini.setvalue 1
#delimit cr
end



*  ----------------------------------------------------------------------------
*  2- PRCWEL                                                          
*  ----------------------------------------------------------------------------
cap program drop ex_prc_02
program ex_prc_02
#delimit ; 
sysuse Mexico_2014.dta , replace; 
gen prc_Combustible    = -0.10;
gen prc_Communication  = -0.06;
gen prc_Cereals        =  0.08;
prcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(prcwel_example_2) nitems(3)  
it1( sn(Combustible)   it(pcexp_comb)    prc(prc_Combustible)   ) 
it2( sn(Communication) it(pcexp_comu)    prc(prc_Communication)   ) 
it3( sn(Cereals)       it(pcexp_cereal)  prc(prc_Cereals)  ) 
epsilon(.5)  
xfil(example2)  
;
#delimit cr
end


cap program drop ex_prc_db_02
program ex_prc_db_02
sysuse Mexico_2014.dta , replace
gen prc_Combustible    = -0.10
gen prc_Communication  = -0.06
gen prc_Cereals        =  0.08
discard
db prcwel
.prcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.prcwel_dlg.main.vn_hhs.setvalue "hhsize"
.prcwel_dlg.main.vn_pl1.setvalue "pline"
.prcwel_dlg.main.cb_meas.setvalue "1"
.prcwel_dlg.main.cb_model.setvalue "1"
.prcwel_dlg.main.ed_subs.setvalue ".6"
.prcwel_dlg.main.ed_epsilon.setvalue ".5"
.prcwel_dlg.main.ed_theta.setvalue "0"
.prcwel_dlg.main.dbsamex.setvalue "prcwel_example_2"
.prcwel_dlg.main.vn_hhg.setvalue ""
.prcwel_dlg.tb_options_pr_ind.ck_excel.seton
.prcwel_dlg.tb_options_pr_ind.fnamex.setvalue "example2"
.prcwel_dlg.items_info_pr_ind.en_sn1.setvalue  "Combustible"
.prcwel_dlg.items_info_pr_ind.vn_item1.setvalue  "pcexp_comb"
.prcwel_dlg.items_info_pr_ind.en_prc1.setvalue  "prc_Combustible"
.prcwel_dlg.items_info_pr_ind.en_sn2.setvalue  "Communication"
.prcwel_dlg.items_info_pr_ind.vn_item2.setvalue  "pcexp_comu"
.prcwel_dlg.items_info_pr_ind.en_prc2.setvalue  "prc_Communication"
.prcwel_dlg.items_info_pr_ind.en_sn3.setvalue  "Cereals"
.prcwel_dlg.items_info_pr_ind.vn_item3.setvalue  "pcexp_cereal"
.prcwel_dlg.items_info_pr_ind.en_prc3.setvalue  "prc_Cereals"
.prcwel_dlg.items_info_pr_ind.cb_items.setvalue  3
.prcwel_dlg.items_info_pr_ind.ed_items.setvalue  3
.prcwel_dlg.items_info_pr_ind.cb_ini.setvalue 1
#delimit cr
end



*  ----------------------------------------------------------------------------
*  3- PRCWEL                                                          
*  ----------------------------------------------------------------------------
cap program drop ex_prc_03
program ex_prc_03
#delimit ; 
sysuse Mexico_2014.dta , replace; 
gen prc_Combustible    = -0.10;
gen prc_Communication  = -0.06;
gen prc_Cereals        =  0.08;
prcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(prcwel_example_3) nitems(3)  meas(2)
it1( sn(Combustible)   it(pcexp_comb)    prc(prc_Combustible)   ) 
it2( sn(Communication) it(pcexp_comu)    prc(prc_Communication)   ) 
it3( sn(Cereals)       it(pcexp_cereal)  prc(prc_Cereals)  ) 
epsilon(.5)  
xfil(example3)  
;
#delimit cr
end


cap program drop ex_prc_db_03
program ex_prc_db_03
sysuse Mexico_2014.dta , replace
gen prc_Combustible    = -0.10
gen prc_Communication  = -0.06
gen prc_Cereals        =  0.08
discard
db prcwel
.prcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.prcwel_dlg.main.vn_hhs.setvalue "hhsize"
.prcwel_dlg.main.vn_pl1.setvalue "pline"
.prcwel_dlg.main.cb_meas.setvalue "2"
.prcwel_dlg.main.cb_model.setvalue "1"
.prcwel_dlg.main.ed_subs.setvalue ".6"
.prcwel_dlg.main.ed_epsilon.setvalue ".5"
.prcwel_dlg.main.ed_theta.setvalue "0"
.prcwel_dlg.main.dbsamex.setvalue "prcwel_example_3"
.prcwel_dlg.main.vn_hhg.setvalue ""
.prcwel_dlg.tb_options_pr_ind.ck_excel.seton
.prcwel_dlg.tb_options_pr_ind.fnamex.setvalue "example3"
.prcwel_dlg.items_info_pr_ind.en_sn1.setvalue  "Combustible"
.prcwel_dlg.items_info_pr_ind.vn_item1.setvalue  "pcexp_comb"
.prcwel_dlg.items_info_pr_ind.en_prc1.setvalue  "prc_Combustible"
.prcwel_dlg.items_info_pr_ind.en_elas1.setvalue  "elas1"
.prcwel_dlg.items_info_pr_ind.en_sn2.setvalue  "Communication"
.prcwel_dlg.items_info_pr_ind.vn_item2.setvalue  "pcexp_comu"
.prcwel_dlg.items_info_pr_ind.en_prc2.setvalue  "prc_Communication"
.prcwel_dlg.items_info_pr_ind.en_elas2.setvalue  "elas2"
.prcwel_dlg.items_info_pr_ind.en_sn3.setvalue  "Cereals"
.prcwel_dlg.items_info_pr_ind.vn_item3.setvalue  "pcexp_cereal"
.prcwel_dlg.items_info_pr_ind.en_prc3.setvalue  "prc_Cereals"
.prcwel_dlg.items_info_pr_ind.en_elas3.setvalue  "elas3"
.prcwel_dlg.items_info_pr_ind.cb_items.setvalue  3
.prcwel_dlg.items_info_pr_ind.ed_items.setvalue  3
.prcwel_dlg.items_info_pr_ind.cb_ini.setvalue 1
#delimit cr
end




*  ----------------------------------------------------------------------------
*  4- PRCWEL                                                          
*  ----------------------------------------------------------------------------
cap program drop ex_prc_04
program ex_prc_04
#delimit ; 
sysuse Mexico_2014_Cereals_F.dta, replace;
preserve;
dis "Wait...: Estimation of price and income elasticities.";
qui keep if wcorn!=.;
qui duvm corn wheat rice other, hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) inisave(ex3_duvm_db) indcat(sex educ) indcon(age) csb(0) dregres(0) hgroup(decile);
restore;
matrix elas_price = e(elprice);
matrix elas_income= e(elincome);
gen pc_corn  = -0.1 ;
gen pc_wheat = 0.08 ;
gen pc_rice = -0.06 ;
gen pc_other = 0.05 ;
prcwel pc_income, hsize(hhsize) pline(pline) meas(2) sotm(2) inisave(prcwel_example_4) gvimp(0) nitems(4) matpel(elas_price) matiel(elas_income) it1( sn(Corn) it(pc_exp_corn) prc(pc_corn) ) it2( sn(Wheat) it(pc_exp_wheat) prc(pc_wheat) ) it3( sn(Rice) it(pc_exp_rice) prc(pc_rice) ) it4( sn(Other_Cereals) it(pc_exp_other) prc(pc_other) ) xfil(example4)   
;
#delimit cr
end


cap program drop ex_prc_db_04
program ex_prc_db_04
#delimit ; 
sysuse Mexico_2014_Cereals_F.dta, replace;
preserve;
dis "Wait...: Estimation of price and income elasticities.";
qui keep if wcorn!=.;
qui duvm corn wheat rice other, hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) inisave(ex3_duvm_db) indcat(sex educ) indcon(age) csb(0) dregres(0) hgroup(decile);
restore;
matrix elas_price = e(elprice);
matrix elas_income= e(elincome);
gen pc_corn  = -0.1 ;
gen pc_wheat = 0.08 ;
gen pc_rice = -0.06 ;
gen pc_other = 0.05 ;
#delimit cr
discard
db prcwel
.prcwel_dlg.main.vn_pcexp.setvalue "pc_income"
.prcwel_dlg.main.vn_hhs.setvalue "hhsize"
.prcwel_dlg.main.vn_pl1.setvalue "pline"
.prcwel_dlg.main.cb_meas.setvalue "2"
.prcwel_dlg.main.cb_model.setvalue "1"
.prcwel_dlg.main.cb_stm.setvalue "2"
.prcwel_dlg.main.ed_subs.setvalue ".6"
.prcwel_dlg.main.ed_epsilon.setvalue ".5"
.prcwel_dlg.main.ed_theta.setvalue "0"
.prcwel_dlg.main.dbsamex.setvalue "prcwel_example_4"
.prcwel_dlg.main.vn_hhg.setvalue ""
.prcwel_dlg.items_info_pr_ind.en_sn1.setvalue  "Corn"
.prcwel_dlg.items_info_pr_ind.vn_item1.setvalue  "pc_exp_corn"
.prcwel_dlg.items_info_pr_ind.en_prc1.setvalue  "pc_corn"
.prcwel_dlg.items_info_pr_ind.en_elas1.setvalue  ""
.prcwel_dlg.items_info_pr_ind.en_sn2.setvalue  "Wheat"
.prcwel_dlg.items_info_pr_ind.vn_item2.setvalue  "pc_exp_wheat"
.prcwel_dlg.items_info_pr_ind.en_prc2.setvalue  "pc_wheat"
.prcwel_dlg.items_info_pr_ind.en_elas2.setvalue  ""
.prcwel_dlg.items_info_pr_ind.en_sn3.setvalue  "Rice"
.prcwel_dlg.items_info_pr_ind.vn_item3.setvalue  "pc_exp_rice"
.prcwel_dlg.items_info_pr_ind.en_prc3.setvalue  "pc_rice"
.prcwel_dlg.items_info_pr_ind.en_elas3.setvalue  ""
.prcwel_dlg.items_info_pr_ind.en_sn4.setvalue  "Other_Cereals"
.prcwel_dlg.items_info_pr_ind.vn_item4.setvalue  "pc_exp_other"
.prcwel_dlg.items_info_pr_ind.en_prc4.setvalue  "pc_other"
.prcwel_dlg.items_info_pr_ind.en_elas4.setvalue  ""
.prcwel_dlg.items_info_pr_ind.cb_items.setvalue  4
.prcwel_dlg.items_info_pr_ind.ed_items.setvalue  4
.prcwel_dlg.items_info_pr_ind.cb_ini.setvalue 1"
.prcwel_dlg.items_info_pr_ind.ed_matpel.setvalue  elas_price
.prcwel_dlg.items_info_pr_ind.ed_matiel.setvalue  elas_income
.prcwel_dlg.tb_options_pr_ind.fnamex.setvalue "example4"
#delimit cr
end



*  ----------------------------------------------------------------------------
*  5- PRCWEL                                                         
*  ----------------------------------------------------------------------------


cap program drop ex_prc_05
program ex_prc_05
#delimit ; 
sysuse IOM_EGY2015.dta, replace; 
save   IOM_EGY2015.dta, replace; 
sysuse hh_data_egypt.dta, replace ;
prcwel pcexp, hsize(hhsize) pline(pline) hgroup(Urbrur) inisave(prcwel_example_5) xfil(example5) gvimp(1) 
it1( sn(Electricity and gas) it(pc_D0450) prc(dp_D0450) elas(elas) )  
it2( sn(Purchase of vehicles)  it(pc_G0710) prc(dp_G0710) elas(elas) ) nitems(2) 
iomatrix("IOM_EGY2015.dta") nshocks(5)  
iomodel(1) adshock(1) tyshock(1)  
shock1( secp(45) pr(-8) ) shock2( secp(36) pr(-10) ) shock3( secp(37) pr(-10) )  
shock4( secp(38) pr(-10) ) shock5( secp(39) pr(-10) ) 
isnames(label) iitnames(item) match(code) initems(39)  ioc(1)
;
#delimit cr
end


cap program drop ex_prc_db_05
program ex_prc_db_05
sysuse IOM_EGY2015.dta, replace 
save   IOM_EGY2015.dta, replace
sysuse hh_data_egypt.dta, replace 
discard
db prcwel
.prcwel_dlg.main.vn_pcexp.setvalue "pcexp"
.prcwel_dlg.main.vn_hhs.setvalue "hhsize"
.prcwel_dlg.main.vn_pl1.setvalue "pline"
.prcwel_dlg.main.cb_meas.setvalue "1"
.prcwel_dlg.main.cb_model.setvalue "1"
.prcwel_dlg.main.cb_stm.setvalue "1"
.prcwel_dlg.main.ed_subs.setvalue ".6"
.prcwel_dlg.main.ed_epsilon.setvalue ".5"
.prcwel_dlg.main.ed_theta.setvalue "0"
.prcwel_dlg.main.dbsamex.setvalue "prcwel_example_5"
.prcwel_dlg.main.vn_hhg.setvalue "Urbrur"
.prcwel_dlg.tb_options_pr_ind.ck_excel.seton
.prcwel_dlg.tb_options_pr_ind.fnamex.setvalue "example5"
.prcwel_dlg.items_info_pr_ind.en_sn1.setvalue  "Electricity and gas"
.prcwel_dlg.items_info_pr_ind.vn_item1.setvalue  "pc_D0450"
.prcwel_dlg.items_info_pr_ind.en_prc1.setvalue  "dp_D0450"
.prcwel_dlg.items_info_pr_ind.en_elas1.setvalue  "elas"
.prcwel_dlg.items_info_pr_ind.en_sn2.setvalue  "Purchase of vehicles"
.prcwel_dlg.items_info_pr_ind.vn_item2.setvalue  "pc_G0710"
.prcwel_dlg.items_info_pr_ind.en_prc2.setvalue  "dp_G0710"
.prcwel_dlg.items_info_pr_ind.en_elas2.setvalue  "elas"
.prcwel_dlg.items_info_pr_ind.cb_items.setvalue  2
.prcwel_dlg.items_info_pr_ind.ed_items.setvalue  2
.prcwel_dlg.items_info_pr_ind.cb_ini.setvalue 1"
.prcwel_dlg.items_info_pr_ind.ed_matpel.setvalue  
.prcwel_dlg.items_info_pr_ind.ed_matiel.setvalue  
.prcwel_dlg.items_info_pr_indeff.cb_ioap.setvalue 1"
.prcwel_dlg.items_info_pr_indeff.cb_ioap_sh.setvalue 1"
.prcwel_dlg.items_info_pr_indeff.cb_ioap_ad.setvalue 1"
.prcwel_dlg.items_info_pr_indeff.dbiom.setvalue "IOM_EGY2015.dta"
.prcwel_dlg.items_info_pr_indeff.var_ms.setvalue "code"
.prcwel_dlg.items_info_pr_indeff.cb_nshocks.setvalue  5
.prcwel_dlg.items_info_pr_indeff.ed_secp1.setvalue  "45"
.prcwel_dlg.items_info_pr_indeff.ed_pr1.setvalue    "-8"
.prcwel_dlg.items_info_pr_indeff.ed_secp2.setvalue  "36"
.prcwel_dlg.items_info_pr_indeff.ed_pr2.setvalue    "-10"
.prcwel_dlg.items_info_pr_indeff.ed_secp3.setvalue  "37"
.prcwel_dlg.items_info_pr_indeff.ed_pr3.setvalue    "-10"
.prcwel_dlg.items_info_pr_indeff.ed_secp4.setvalue  "38"
.prcwel_dlg.items_info_pr_indeff.ed_pr4.setvalue    "-10"
.prcwel_dlg.items_info_pr_indeff.ed_secp5.setvalue  "39"
.prcwel_dlg.items_info_pr_indeff.ed_pr5.setvalue    "-10"
.prcwel_dlg.items_info_pr_indeff.ed_items.setvalue  39
.prcwel_dlg.items_info_pr_indeff.var_sn.setvalue  label
.prcwel_dlg.items_info_pr_indeff.var_item.setvalue  item
.prcwel_dlg.items_info_pr_indeff.var_elas1.setvalue  
.prcwel_dlg.items_info_pr_indeff.var_ms.setvalue  code
.prcwel_dlg.items_info_pr_indeff.chk_per21.seton
#delimit cr
end



