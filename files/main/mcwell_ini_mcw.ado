



cap program drop mcwell_ini_mcw
program mcwell_ini_mcw
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global ini_mcwel `dof'
	
	discard
    db mcwel
    
end


