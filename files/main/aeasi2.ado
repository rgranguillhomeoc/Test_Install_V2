
cap program drop aeasi2
program aeasi2
        version 10
        local inis $easi_db_ini
        global prg_pointer = "main"
        if "`inis'"~="" {
        cap do "`inis'.easi"
        }
        cap macro drop easi_db_ini 
        global tempprj `inis'
end
