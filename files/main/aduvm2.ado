
cap program drop aduvm2
program aduvm2
        version 10
        local inis $duvm_db_ini
        global prg_pointer = "main"
        if "`inis'"~="" {
        cap do "`inis'.duvm"
        }
        cap macro drop duvm_db_ini 
        global tempprj `inis'
end
