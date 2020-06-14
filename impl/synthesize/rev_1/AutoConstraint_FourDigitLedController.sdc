
#Begin clock constraint
define_clock -name {FourDigitLedController|clock} {p:FourDigitLedController|clock} -period 6.081 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 3.041 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {FourDigitLedController|serialClockIn} {p:FourDigitLedController|serialClockIn} -period 3.425 -clockgroup Autoconstr_clkgroup_1 -rise 0.000 -fall 1.712 -route 0.000 
#End clock constraint
