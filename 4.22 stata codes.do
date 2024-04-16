net install matsqrt.pkg, from(http://www.stata.com/users/jpitblado) replace
ssc install gcrobustvar, replace
net describe st0581, from(http://www.stata-journal.com/software/sj19-4)
net get st0581, from(http://www.stata-journal.com/software/sj19-4)
import excel "\\ad.ucl.ac.uk\home3\ucesj23\DesktopSettings\Desktop\4.22data.xlsx", sheet("Sheet1") firstrow
generate days = td(31dec2019)+_n-1
format %td days
tsset days
gen BITlog_return = log( Bitcoin / L.Bitcoin ) * 100
replace BITlog_return = 0 if _n == 1
gen NGlog_return = log( NaturalGas / L.NaturalGas ) * 100
replace NGlog_return = 0 if _n == 1
gen GDlog_return = log( Gold / L.Gold ) * 100
replace GDlog_return = 0 if _n == 1
dfuller BITlog_return
dfuller NGlog_return
dfuller GDlog_return
var BITlog_return NGlog_return
varsoc
vargranger
var GDlog_return NGlog_return
varsoc
vargranger
mata
mata clear
mata matuse pvtable,replace
st_matrix("r(pvap0opt)",pvap0opt)
st_matrix("r(pvapiopt)",pvapiopt)
st_matrix("r(pvnybopt)",pvnybopt)
st_matrix("r(pvqlropt)",pvqlropt)
end
matrix pvap0opt = r(pvap0opt)
matrix pvapiopt = r(pvapiopt)
matrix pvnybopt = r(pvnybopt)
matrix pvqlropt = r(pvqlropt)
gcrobustvar NGlog_return GDlog_return, pos(2,1) horizon(0) lags(1/2) trimming(0.1)
gcrobustvar NGlog_return BITlog_return, pos(2,1) horizon(0) lags(1/2) trimming(0.1)