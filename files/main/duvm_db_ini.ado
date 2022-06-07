
cap program drop duvm_db_ini
program duvm_db_ini
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global duvm_db_ini `dof'
	discard
    db duvm
    
end


