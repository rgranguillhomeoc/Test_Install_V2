

cap program drop awapwel2
program awapwel2
	version 10
	local inis $ini_wap
	global prg_pointer = "main"
	if "`inis'"~="" {
	cap do "`inis'.wap"
	}
	cap macro drop ini_wap
	global tempprj `inis'
end
