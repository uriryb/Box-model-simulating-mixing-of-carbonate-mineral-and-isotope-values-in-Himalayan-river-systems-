function [MIX] = mix(x,A,B)
%returns the isotope and mineral mixing values given a mixing ratio X=A/B and
%end-member values vectors A and B

%standard parameters
VSMOW18_16=0.204/99.759;
VSMOW17_16=370/10000/99.759;
VPDB13_12=1.11/98.89;
Lam=0.528; %slope for d17O-d18O mass dependent frationation

%convert VPDB to VSMOW

%extract endmember values
d17OA=Lam*VPDBtoVSMOW(A(1));
d17OB=Lam*VPDBtoVSMOW(B(1));
D47A=Magali_D47(A(3)); %convert temperature to D47ARF values
D47B=Magali_D47(B(3)); %convert temperature to D47ARF values
calA=A(4);
dolA=A(5);
calB=B(4);
dolB=B(5);
X=x*calA/(x*calA+(1-x)*calB);% mixing ratio for calcite

%calculate isotope ratios in each endmember
R18A=(VPDBtoVSMOW(A(1))/1000+1)*VSMOW18_16;
R13A=(A(2)/1000+1)*VPDB13_12;
R17A=(d17OA/1000+1)*VSMOW17_16;
R47stoA=2*R18A*R13A+2*R17A*R18A+R13A*R17A^2;
R47A=(D47A/1000+1)*R47stoA;

R18B=(VPDBtoVSMOW(B(1))/1000+1)*VSMOW18_16;
R13B=(B(2)/1000+1)*VPDB13_12;
R17B=(d17OB/1000+1)*VSMOW17_16;
R47stoB=2*R18B*R13B+2*R17B*R18B+R13B*R17B^2;
R47B=(D47B/1000+1)*R47stoB;

%Calculate isotope mixing ratios
R18mix=(R18A*X/(R18A+1)+R18B*(1-X)/(R18B+1))/...
                    (X/(R18A+1)+(1-X)/(R18B+1));

R13mix=(R13A*X/(R13A+1)+R13B*(1-X)/(R13B+1))/...
                    (X/(R13A+1)+(1-X)/(R13B+1));
                
R17mix=(R17A*X/(R17A+1)+R17B*(1-X)/(R17B+1))/...
                    (X/(R17A+1)+(1-X)/(R17B+1));         
             
R47mix=(R47A*X/(R47A+1)+R47B*(1-X)/(R47B+1))/...
                    (X/(R47A+1)+(1-X)/(R47B+1));

R47sto_mix=2*R18mix*R13mix+2*R17mix*R18mix+R13mix*R17mix^2; %calculate stochastic distribtion of 47/44 in mixture              
d18Omix=VSMOWtoVPDB((R18mix/VSMOW18_16-1)*1000); % calculate mixture d18O vpdb
d13Cmix=(R13mix/VPDB13_12-1)*1000; % calculate mixture d13C vpdb
%d17Omix=(R17mix/VSMOW17_16-1)*1000; % calculate mixture d17O vpdb
D47mix=(R47mix/R47sto_mix-1)*1000; % calculate mixture D47 ARF
T47mix=Magali_Temp(D47mix);        % convert mixture D47 to T47
cal_mix=x*calA+(1-x)*calB;         % calculate mixture calcite wt%
dol_mix=x*dolA+(1-x)*dolB;         % calculate mixture dolomite wt%
MIX =[d18Omix,d13Cmix,T47mix,cal_mix,dol_mix]; 
end

