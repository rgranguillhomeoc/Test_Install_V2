
cap program drop almcwel
program almcwel
	version 10
	local inis $ini_lmc
	if "`inis'"~="" {
	cap do "`inis'.lmc"
	}
	cap macro drop ini_lmc
	global tempprj `inis'
end
