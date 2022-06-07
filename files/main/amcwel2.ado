

cap program drop amcwel2
program amcwel2
	version 10
	local inis $ini_mcwel
	global prg_pointer = "main"
	if "`inis'"~="" {
	cap do "`inis'.mcw"
	}
	cap macro drop ini_mcwel 
	global tempprj `inis'
end
