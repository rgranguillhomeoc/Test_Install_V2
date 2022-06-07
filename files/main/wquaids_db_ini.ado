
cap program drop wquaids_db_ini
program wquaids_db_ini
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global wquaids_db_ini `dof'
	discard
    db wquaids
    
end


