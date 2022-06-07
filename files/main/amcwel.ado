


cap program drop amcwel
program amcwel
	version 10
	local inis $ini_mcw
	if "`inis'"~="" {
	cap do "`inis'.mcw"
	}
	cap macro drop ini_mcw
	global tempprj `inis'
end
