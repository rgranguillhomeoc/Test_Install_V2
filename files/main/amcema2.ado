
cap program drop amcema2
program amcema2
        version 10
        local inis $mcema_db_ini
        global prg_pointer = "main"
        if "`inis'"~="" {
        cap do "`inis'.mcema"
        }
        cap macro drop mcema_db_ini 
        global tempprj `inis'
end
