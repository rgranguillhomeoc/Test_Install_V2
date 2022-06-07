
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace; 
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace; 
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace; 
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other, 
hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex1_duvm_db)  indcat(sex educ )  indcon(age)   xfil(myfile) 
 ;
#delimit cr
end


cap program drop ex_duvm_02
program ex_duvm_02
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace; 
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace; 
duvm corn wheat rice other, 
hhsize(hhsize) expend(hh_current_inc) hweight(sweight) cluster(psu) region(rururb) 
inisave(ex3_duvm_db)  indcat(sex educ )  indcon(age)   xfil(myfile) 
hgroup(decile)
 ;
#delimit cr              
end

cap program drop ex_duvm_db_01
program ex_duvm_db_01
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace;
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace; 
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace;
set seed 1234;
bsample 4000;
 sr_easi wcorn wwheat wrice wother wcomp, 
 prices(pcorn pwheat price pother pcomp) 
 snames(corn wheat rice other comp) 
 expenditure(hh_current_inc) inisave(myproj) 
 rtool(C:\Program Files\R\R-3.4.4\bin\x64\R.exe) 
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
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace;
set seed 1234;
bsample 4000;
 sr_easi wcorn wwheat wrice wother wcomp, 
 prices(pcorn pwheat price pother pcomp) 
 snames(corn wheat rice other comp) 
 expenditure(hh_current_inc) inisave(myproj) 
 rtool(C:\Program Files\R\R-3.4.4\bin\x64\R.exe) 
 demographics(age isMale educa2 educa3 educa4 educa5 educa6 educa7) 
 dec(4) dregres(1) dislas(0) 
 xfil(myres) 
 power(5) 
 inpy(1) inpz(1) inzy(0);
#delimit cr
end

cap program drop ex_easi_db_01
program ex_easi_db_01
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
.sr_easi_dlg.main.drtool.setvalue "C:\Program Files\R\R-3.4.4\bin\x64\R.exe"
.sr_easi_dlg.resop.sp_dec.setvalue "4"
.sr_easi_dlg.resop.eldecfile.setvalue "myres"
#delimit cr
end


cap program drop ex_easi_db_02
program ex_easi_db_02
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace
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
.sr_easi_dlg.main.drtool.setvalue "C:\Program Files\R\R-3.4.4\bin\x64\R.exe"
.sr_easi_dlg.resop.sp_dec.setvalue "4"
.sr_easi_dlg.resop.eldecfile.setvalue "myres"
#delimit cr
end



cap program drop ex_sids_01
program ex_sids_01
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace;
sids hh_q_corn pcorn hh_current_inc, hgroup(quintile)  indcon(age) ;
#delimit cr
end

cap program drop ex_sids_02
program ex_sids_02
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/ds/Mexico_2014_Cereals.dta , replace;
sids hh_q_corn pcorn hh_current_inc, hgroup(sex) incpar(decile) indcon(age) incint(1)  xfil(myres)  dgra(1) ;
#delimit cr
end

cap program drop ex_lmc_01
program ex_lmc_01
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace; 
lmcwel pc_income, hhid(folioviv foliohog) hsize(hhsize) pline(pline) 
inisave(myexp) 
incomes(http://dasp.ecn.ulaval.ca/welcom/examples/lmc/incomes.dta) 
sectors(http://dasp.ecn.ulaval.ca/welcom/examples/lmc/sectors.dta) 
epsilon(.5) xfil(myexcel) folgr(mygraphs)
;
#delimit cr
end




cap program drop ex_lmc_db_01
program ex_lmc_db_01
use http://dasp.ecn.ulaval.ca/welcom/examples/lmc/Mexico_2014.dta , replace
discard
db lmcwel
.lmcwel_dlg.main.dbsamex.setvalue "myexp"
.lmcwel_dlg.labor_info_lmcwel.sectors.setvalue "http://dasp.ecn.ulaval.ca/welcom/examples/lmc/sectors.dta"
.lmcwel_dlg.labor_info_lmcwel.incomes.setvalue "http://dasp.ecn.ulaval.ca/welcom/examples/lmc/incomes.dta"
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
use http://dasp.ecn.ulaval.ca/welcom/examples/wap/Mexico_2014_WAP.dta , replace; 
wapwel pc_income, hsize(hhsize) pline(pline) inisave(myexp) nitems(11) itnames(itnames) 
itvnames(vnnames) match(match_sec) iomatrix(http://dasp.ecn.ulaval.ca/welcom/examples/wap/SAM_MEX_2003.dta) 
secnames(secnames) opgr1( max(0.95) ) xfil(myfile)
;
#delimit cr
end




cap program drop ex_wap_db_01
program ex_wap_db_01
use http://dasp.ecn.ulaval.ca/welcom/examples/wap/Mexico_2014_WAP.dta , replace
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
.wapwel_dlg.items_info_ind.dbiom.setvalue "http://dasp.ecn.ulaval.ca/welcom/examples/wap/SAM_MEX_2003.dta"
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
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(1) grmod1(psu) welfare(pc_income) hsize(hhsize) hgroup(tam_loc) 
indcat(socio educ) indcon(hhsize) pswp(.05) pchange(pchange) ichange(change_in_income) expshare(eshare) 
 um(1) dec(3) inisave(example1) xfil(myres1)
;
#delimit cr
end


cap program drop ex_mcema_db_01
program ex_mcema_db_01
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014_Cellphones.dta , replace
discard
db mcema
.mcema_dlg.main.dbsamex.setvalue "example1"
.mcema_dlg.main.vn_d_cons.setvalue d_cell
.mcema_dlg.main.vn_d_consc.setvalue pc_exp_cell
.mcema_dlg.main.vn_pr.setvalue 
.mcema_dlg.main.vn_inc.setvalue pc_income
.mcema_dlg.main.vn_hhs.setvalue hhsize
.mcema_dlg.main.vn_hg.setvalue tam_loc
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
.mcema_dlg.main.cb_cpri.setvalue 1
.mcema_dlg.main.cb_cons.setvalue 1
.mcema_dlg.main.cb_cinc.setvalue 1
.mcema_dlg.main.ed_oopt.setvalue 
.mcema_dlg.main.vl_indcatc.setvalue 
.mcema_dlg.main.vl_indconc.setvalue 
.mcema_dlg.main.vn_pchange.setvalue pchange
.mcema_dlg.main.vn_ichange.setvalue change_in_income
.mcema_dlg.main.fl_pswe.setvalue 1
.mcema_dlg.resop.ck_excel.seton
.mcema_dlg.resop.fnamex.setvalue "myres1"
.mcema_dlg.resop.sp_dec.setvalue 3
#delimit cr
end






cap program drop ex_mcema_02
program ex_mcema_02
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014_Cellphones.dta , replace; 
mcema d_cell pc_exp_cell, expmod(4) grmod1(decile) grmod2(tam_loc) welfare(pc_income) hsize(hhsize) 
hgroup(tam_loc) incpar(quintile) indcat(socio educ) indcon(hhsize) pswp(.05) pswe(.05) 
pchange(pchange) ichange(change_in_income) expshare(eshare) 
um(1) dec(3) fex(2) fpr(3) fin(2) cindcat(sex) cindcon(age) inisave(example) xfil(myres2);
#delimit cr
end

cap program drop ex_mcema_db_02
program ex_mcema_db_02
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014_Cellphones.dta , replace
discard
db mcema
.mcema_dlg.main.dbsamex.setvalue "example"
.mcema_dlg.main.vn_d_cons.setvalue d_cell
.mcema_dlg.main.vn_d_consc.setvalue pc_exp_cell
.mcema_dlg.main.vn_pr.setvalue 
.mcema_dlg.main.vn_inc.setvalue pc_income
.mcema_dlg.main.vn_hhs.setvalue hhsize
.mcema_dlg.main.vn_hg.setvalue tam_loc
.mcema_dlg.main.vn_incpar.setvalue quintile
.mcema_dlg.main.vl_indcat.setvalue socio educ
.mcema_dlg.main.vl_indcon.setvalue hhsize
.mcema_dlg.main.fl_pswp.setvalue .05
.mcema_dlg.main.ck_swp.seton
.mcema_dlg.main.com_um.setvalue 1
.mcema_dlg.main.ck_adj.seton
.mcema_dlg.main.vn_share.setvalue eshare
.mcema_dlg.main.cb_moda.setvalue 3 
.mcema_dlg.main.gr_moda1.setvalue decile
.mcema_dlg.main.gr_moda2.setvalue tam_loc
.mcema_dlg.main.cb_cpri.setvalue 3
.mcema_dlg.main.cb_cons.setvalue 2
.mcema_dlg.main.cb_cinc.setvalue 2
.mcema_dlg.main.ed_oopt.setvalue 
.mcema_dlg.main.vl_indcatc.setvalue sex
.mcema_dlg.main.vl_indconc.setvalue age
.mcema_dlg.main.vn_pchange.setvalue pchange
.mcema_dlg.main.vn_ichange.setvalue change_in_income
.mcema_dlg.main.fl_pswe.setvalue .05
.mcema_dlg.main.ck_swe.seton
.mcema_dlg.resop.ck_excel.seton
.mcema_dlg.resop.fnamex.setvalue "myres2"
.mcema_dlg.resop.sp_dec.setvalue 3

#delimit cr
end






*  ----------------------------------------------------------------------------
*  3- MCEMA                                                         
*  ----------------------------------------------------------------------------
cap program drop ex_prc_03
program ex_prc_03
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/mydata.dta , replace; 
mcema hasmobile pc_totaldexp, expmod(3) welfare(pc_totaldexp) hgroup(CQ11) indcat(Education 
Electricity emp_status) indcon(rural Floor Wall sex Head_HH Age HH_SIZE) pswe(.05) 
pchange(price_change) disgr(CQ11) um(5) dec(3) fex(2) fpr(3) fin(2) exnum(1) 
grmac(CQ11) totuser(total_users) cindcat(Education Electricity emp_status) 
cindcon(rural Floor Wall sex Head_HH Age HH_SIZE) 
inisave(example3) xfil(myres3)
;  
#delimit cr
end


cap program drop ex_prc_db_03
program ex_prc_db_03
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/mydata.dta , replace
db mcema
.mcema_dlg.main.dbsamex.setvalue "C:\Users\abara\Desktop\mcema_mac\example3"
.mcema_dlg.main.vn_d_cons.setvalue hasmobile
.mcema_dlg.main.vn_d_consc.setvalue pc_totaldexp
.mcema_dlg.main.vn_pr.setvalue 
.mcema_dlg.main.vn_inc.setvalue pc_totaldexp
.mcema_dlg.main.vn_hhs.setvalue 
.mcema_dlg.main.vn_hg.setvalue CQ11
.mcema_dlg.main.vn_incpar.setvalue 
.mcema_dlg.main.vl_indcat.setvalue Education Electricity emp_status
.mcema_dlg.main.vl_indcon.setvalue rural Floor Wall sex Head_HH Age HH_SIZE
.mcema_dlg.resop.var_disgr.setvalue CQ11
.mcema_dlg.main.fl_pswp.setvalue 1
.mcema_dlg.main.com_um.setvalue 5
.mcema_dlg.main.vn_share.setvalue 
.mcema_dlg.main.cb_mac.setvalue 2 
.mcema_dlg.main.cb_moda.setvalue 3 
.mcema_dlg.main.ed_modaq1.setvalue  
.mcema_dlg.main.gr_moda1.setvalue 
.mcema_dlg.main.gr_moda2.setvalue 
.mcema_dlg.main.cb_cpri.setvalue 3
.mcema_dlg.main.cb_cons.setvalue 2
.mcema_dlg.main.cb_cinc.setvalue 2
.mcema_dlg.main.ed_oopt.setvalue 
.mcema_dlg.main.vl_indcatc.setvalue Education Electricity emp_status
.mcema_dlg.main.vl_indconc.setvalue rural Floor Wall sex Head_HH Age HH_SIZE
.mcema_dlg.main.vn_pchange.setvalue price_change
.mcema_dlg.main.vn_ichange.setvalue 
.mcema_dlg.main.fl_pswe.setvalue .05
.mcema_dlg.main.ck_swe.seton
.mcema_dlg.resop.ck_excel.seton
.mcema_dlg.resop.fnamex.setvalue "myres3"
.mcema_dlg.resop.sp_dec.setvalue 3
.mcema_dlg.main.ck_mac.seton
.mcema_dlg.main.gr_mac.setvalue CQ11
.mcema_dlg.main.var_tent.setvalue 
.mcema_dlg.main.var_tuse.setvalue total_users
.mcema_dlg.main.eli_mac.setvalue 
#delimit cr
end





cap program drop ex_prc_01
program ex_prc_01
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace; 
gen prc_Cereals=0.08;
prcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(prwel_example_01) nitems(1)  
it1( sn(Cereals)       it(pcexp_cereal)  prc(prc_Cereals)  ) 
epsilon(.5)  
xfil(myexample1)  
;
#delimit cr
end


cap program drop ex_prc_db_01
program ex_prc_db_01
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace
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
.prcwel_dlg.tb_options_pr.ck_excel.seton
.prcwel_dlg.tb_options_pr.fnamex.setvalue "myexample1"
.prcwel_dlg.items_info_pr.en_sn1.setvalue  "Cereals"
.prcwel_dlg.items_info_pr.vn_item1.setvalue  "pcexp_cereal"
.prcwel_dlg.items_info_pr.en_prc1.setvalue  "prc_Cereals"
.prcwel_dlg.items_info_pr.cb_items.setvalue  1
.prcwel_dlg.items_info_pr.ed_items.setvalue  1
.prcwel_dlg.items_info_pr.cb_ini.setvalue 1
#delimit cr
end



*  ----------------------------------------------------------------------------
*  2- PRCWEL                                                          
*  ----------------------------------------------------------------------------
cap program drop ex_prc_02
program ex_prc_02
#delimit ; 
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace; 
gen prc_Combustible    = -0.10;
gen prc_Communication  = -0.06;
gen prc_Cereals        =  0.08;
prcwel pc_income, hsize(hhsize) pline(pline) gvimp(1) 
inisave(prwel_example_02) nitems(3)  
it1( sn(Combustible)   it(pcexp_comb)    prc(prc_Combustible)   ) 
it2( sn(Communication) it(pcexp_comu)    prc(prc_Communication)   ) 
it3( sn(Cereals)       it(pcexp_cereal)  prc(prc_Cereals)  ) 
epsilon(.5)  
xfil(myexample2)  
;
#delimit cr
end


cap program drop ex_prc_db_02
program ex_prc_db_02
use http://dasp.ecn.ulaval.ca/welcom/examples/mc/Mexico_2014.dta , replace
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
.prcwel_dlg.main.dbsamex.setvalue "prcwel_example_02"
.prcwel_dlg.main.vn_hhg.setvalue ""
.prcwel_dlg.tb_options_pr.ck_excel.seton
.prcwel_dlg.tb_options_pr.fnamex.setvalue "myexample2"
.prcwel_dlg.items_info_pr.en_sn1.setvalue  "Combustible"
.prcwel_dlg.items_info_pr.vn_item1.setvalue  "pcexp_comb"
.prcwel_dlg.items_info_pr.en_prc1.setvalue  "prc_Combustible"
.prcwel_dlg.items_info_pr.en_sn2.setvalue  "Communication"
.prcwel_dlg.items_info_pr.vn_item2.setvalue  "pcexp_comu"
.prcwel_dlg.items_info_pr.en_prc2.setvalue  "prc_Communication"
.prcwel_dlg.items_info_pr.en_sn3.setvalue  "Cereals"
.prcwel_dlg.items_info_pr.vn_item3.setvalue  "pcexp_cereal"
.prcwel_dlg.items_info_pr.en_prc3.setvalue  "prc_Cereals"
.prcwel_dlg.items_info_pr.cb_items.setvalue  3
.prcwel_dlg.items_info_pr.ed_items.setvalue  3
.prcwel_dlg.items_info_pr.cb_ini.setvalue 1
#delimit cr
end


