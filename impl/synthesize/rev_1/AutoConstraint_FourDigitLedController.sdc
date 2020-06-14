
#Begin clock constraint
define_clock -name {FourDigitLedController|clock} {p:FourDigitLedController|clock} -period 10.000 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 5.000 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {FourDigitLedController|serialFiltered_derived_clock[1]} {n:FourDigitLedController|serialFiltered_derived_clock[1]} -period 10.000 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 5.000 -route 0.000 
#End clock constraint
