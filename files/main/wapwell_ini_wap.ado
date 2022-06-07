



cap program drop wapwell_ini_wap
program wapwell_ini_wap
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global ini_wap `dof'
	
	discard
    db wapwel
    
end


