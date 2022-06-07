



cap program drop lmcwell_ini_lmc
program lmcwell_ini_lmc
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global ini_lmc `dof'
	
	discard
    db lmcwel
    
end


