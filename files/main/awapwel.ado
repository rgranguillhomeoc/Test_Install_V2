
cap program drop awapwel
program awapwel
	version 10
	local inis $ini_wap
	if "`inis'"~="" {
	cap do "`inis'.wap"
	}
	cap macro drop ini_wap
	global tempprj `inis'
end
