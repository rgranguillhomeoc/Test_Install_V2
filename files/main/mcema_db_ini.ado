
cap program drop mcema_db_ini
program mcema_db_ini
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global mcema_db_ini `dof'
	discard
    db mcema
    
end


