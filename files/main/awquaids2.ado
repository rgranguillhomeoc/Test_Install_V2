
cap program drop awquaids2
program awquaids2
        version 10
        local inis $wquaids_db_ini
        global prg_pointer = "main"
        if "`inis'"~="" {
        cap do "`inis'.wquaids"
        }
        cap macro drop wquaids_db_ini 
        global tempprj `inis'
end
