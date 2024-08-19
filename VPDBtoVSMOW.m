function [VSMOW] = VPDBtoVSMOW(VPDB)
%convert d18O values from VPDB to VSMOW reference frame
VSMOW=VPDB*1.03092+30.92;
end

