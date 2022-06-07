

cap program drop almcwel2
program almcwel2
	version 10
	local inis $ini_lmc
	global prg_pointer = "main"
	if "`inis'"~="" {
	cap do "`inis'.lmc"
	}
	cap macro drop ini_lmc
	global tempprj `inis'
end
