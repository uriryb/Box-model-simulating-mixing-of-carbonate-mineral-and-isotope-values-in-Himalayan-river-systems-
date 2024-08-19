function [VPDB] = VSMOWtoVPDB(VSMOW)
%convert d18O values from VSMOW to VPDB reference frame
VPDB=(VSMOW-30.92)/1.03092;
end