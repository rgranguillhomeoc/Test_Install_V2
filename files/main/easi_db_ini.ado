
cap program drop easi_db_ini
program easi_db_ini
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global easi_db_ini `dof'
	discard
    db sr_easi
    
end


