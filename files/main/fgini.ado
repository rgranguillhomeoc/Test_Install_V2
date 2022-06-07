*! version 1.0  15feb2007 Z. Sajaia // changed by Araar 2017
cap program drop fgini
program define fgini, rclass
        syntax varname [if] [in] [pweight fweight]
        version 9.2

if missing("`check'") {
        tempvar goodx

        marksample touse
        quietly generate `goodx' = 1 if (`varlist' > 0)
        markout `touse'  `goodx' `varlist'
        quietly count if `touse'

}

        if ~missing("`exp'") {
                tempvar w
                generate double `w' `exp'
        }
        local vlist "`varlist' `w'"

        tempname gini


        mata: mata_callfgini()

        display as text _n "Gini coefficient = " as result %9.7f `gini'
       
        return scalar gini = `gini'
end

mata:
mata clear
void function mata_callfgini()
{
        RET = fgini(st_data( .,tokens(st_local("vlist")),  st_local("touse")), st_local("weight"))

        st_numscalar(st_local("gini"), RET[1,1])
}

real matrix function fgini(real matrix X, | string scalar weight)
{
        colvector Xi, WX
        N = rows(X)
		R = X[order(X,1),]
        M = N
        Xi=.
        C = cols(R)
        R = R \ J(1, C, .)

        if (C == 1) {
                sumW=N
        }
        else {
                WX  =R[., 1]:*R[., 2]
                sumW=quadcolsum(R)[1,2]
        }

        sumWX=0
                if (C == 1) {
                        sumWX=quadcross(R, ((M::1):*2:-1) \ .)*0.5
                        sumX=quadcolsum(R)
                }
                else {
                        sumX =0
                        for (i=1; i<=M; ++i) {
                                sumWX = sumWX + R[i, 2]*(sumX+WX[i]*0.5)
                                sumX  = sumX  + WX[i]
                        }
                }
                g = 1- 2*sumWX/sumW/sumX
                RET = g
        
        return(RET)
}

end

