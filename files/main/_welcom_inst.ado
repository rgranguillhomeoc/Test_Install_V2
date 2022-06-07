
*! version 3.60
*
capture program drop _welcom_inst
program define _welcom_inst

set more off
net from http://dasp.ecn.ulaval.ca/welcom/Installer36
net install welcom_p1,   force
net install welcom_p2,   force
net install welcom_p3,   force
net install welcom_p4,   force
net get     welcom_data, force
cap addITMenu profile.do _welcom_menu

end


