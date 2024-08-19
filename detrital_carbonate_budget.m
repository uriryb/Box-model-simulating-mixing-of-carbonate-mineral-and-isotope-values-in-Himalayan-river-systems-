% This model simulated the evolution of detrital carbonate 
% mineral and isotope compositions during river transport 
% It considers input from Tethyan Himalaya and Lesser Himalaya sources,
% addition of secondary calcite and preferential dissolution of calcite 
clear 
%Get empirical data from xls source file
Dataturb=xlsread('BoB_data_Calcite_Turb');
D47data_turb=Dataturb(:,1);
D47data_SE_turb=Dataturb(:,2);
d13Cdata_turb=Dataturb(:,3);
d13Cdata_SD_turb=Dataturb(:,4);
d18Odata_turb=Dataturb(:,5);
d18Odata_SD_turb=Dataturb(:,6);
TD47data_turb=Dataturb(:,7);
TD47data_SE_turb=Dataturb(:,8);
cal_dol_data_turb=Dataturb(:,9);
dol_cal_data_turb=Dataturb(:,10);
dol_carb_data_turb=Dataturb(:,11);
cal_carb_data_turb=Dataturb(:,12);
Al_Si_data_turb=Dataturb(:,13);
%define endmember components:
d18O_TH=-14;    %Tethyan Himalaya calcite d18O vpdb
d13C_TH=0;      %Tethyan Himalaya calcite d13C vpdb
TD47_TH=184;    %Tethyan Himalaya clumped isotope temperature
Cal_TH=20;      %Tethyan Himalaya calcite wt%
Dol_TH=4;       %Tethyan Himalaya dolomite wt%

d18O_LH=-14;    %Lesser Himalaya calcite d18O vpdb
d13C_LH=0;     %Lesser Himalaya calcite d13C vpdb
TD47_LH=184;    %Lesser Himalaya clumped isotope temperature
Cal_LH=0.5;     %Lesser Himalaya calcite wt%
Dol_LH=4;       %Lesser Himalaya dolomite wt%

d18O_SEC=-10;    %Secondary floodplain calcite d18O vpdb
d13C_SEC=-2;     %Secondary floodplain calcite d13C vpdb
TD47_SEC=19;     %Secondary floodplain calcite clumped isotope temperature
Cal_SEC=5;       %Secondary floodplain calcite wt%
Dol_SEC=0;       %Secondary floodplain dolomite wt%

%simplified linear dissolution fluxes
Trans_t=54;     %time in transport (dimensionless)
cal_diss=0.25;  %calcite dissolution rate (wt% per time unit)
dol_diss=0.03;  %dolomite dissolution rate (wt% per time unit)

% generate endmember vectors
TH=[d18O_TH,d13C_TH,TD47_TH,Cal_TH,Dol_TH];
LH=[d18O_LH,d13C_LH,TD47_LH,Cal_LH,Dol_LH];
SEC=[d18O_SEC,d13C_SEC,TD47_SEC,Cal_SEC,Dol_SEC];

%%%%%Scenario 1 - varying X_TH%%%%%%%%%%%%%%

X_Him=0.7;   %relative contribution Himalayan flux after dissolution X_Him=Him/(Him+FP) 
%Provenanace effect - mixing of TH and LH 
for i=1:37 %=1:64%mixing proportions for TH/(TH+LH)input into the floodplain 
    X_TH=0.63+(i-1)/100;%=0.36(i-1)/100;
    Him_input(i,:)=mix(X_TH,TH,LH); %calculates mineral and isotopic properties of mixed himalayan detrital input
    Him_input_diss(i,:)=Him_input(i,:);
    Him_input_diss(i,4)=Him_input(i,4)-cal_diss*Trans_t;
    Him_input_diss(i,5)=Him_input(i,5)-dol_diss*Trans_t;
        
    if Him_input_diss(i,4)<0
       Him_input_diss(i,4)=0;
    end
    if Him_input_diss(i,5)<0
       Him_input_diss(i,5)=0;
    end
    
    FP_output(i,:)=mix(X_Him,Him_input_diss(i,:),SEC); %Calculate final mixing ratio by addition of Secondary calcite
    ratio(i)=FP_output(i,4)/(FP_output(i,4)+FP_output(i,5)); %calculate dol/(cal+dol) ratio
end

figure (1)
p1=plot(ratio,FP_output(:,3));
hold on
scatter (cal_carb_data_turb,TD47data_turb,'o');
title('Varying X_TH')
ylabel('T\Delta_{47}')
xlabel('cal/\Sigma carbonate')
% 
% figure (2)
% p2=plot(FP_output(:,1),FP_output(:,3));
% hold on
% scatter(d18Odata_turb,TD47data_turb,'o');
% title('Varying X_TH')
% ylabel('TD47')
% xlabel('d18O(permil VPDB)')
% 
% figure (3)
% p3=plot(FP_output(:,2),FP_output(:,3));
% hold on
% scatter(d13Cdata_turb,TD47data_turb,'o');
% title('Varying X_TH')
% ylabel('TD47')
% xlabel('d13C(permil VPDB)')

%%%%%Scenario II - varying X_Him%%%%%%%%%%%%%%%%%%
% X_TH=0.2;   %relative contribution of Tethyan Himalaya to the total mountain flux =TH/(TH+LH)
% %Provenanace effect - mixing of TH and LH 
% for i=1:101 %mixing proportions for TH/(TH+LH)input into the floodplain 
%     X_Him=(i-1)/100;
%     Him_input(i,:)=mix(X_TH,TH,LH); %calculates mineral and isotopic properties of mixed himalayan detrital input
%     Him_input_diss(i,:)=Him_input(i,:);
%     Him_input_diss(i,4)=Him_input(i,4)-cal_diss*Trans_t;
%     Him_input_diss(i,5)=Him_input(i,5)-dol_diss*Trans_t;
%     
%         
%     if Him_input_diss(i,4)<0
%        Him_input_diss(i,4)=0;
%     end
%     if Him_input_diss(i,5)<0
%        Him_input_diss(i,5)=0;
%     end
%     
%     FP_output(i,:)=mix(X_Him,Him_input_diss(i,:),SEC); %Calculate final mixing ratio by addition of Secondary calcite
%     ratio(i)=FP_output(i,4)/(FP_output(i,4)+FP_output(i,5)); %calculate dol/(cal+dol) ratio
% end
% 
% figure (1)
% p1=plot(ratio,FP_output(:,3));
% hold on
% scatter(cal_carb_data_turb,TD47data_turb,'o');
% title('Varying X_Him')
% ylabel('T\Delta_{47}')
% xlabel('cal/\Sigma carbonate')

%%%%%Scenario III - varying weathering intensity%%%%%%%%%%%%%
% X_TH=0.36;   %relative contribution of Tethyan Himalaya to the total mountain flux =TH/(TH+LH)
% % value of 0.36 is calculated for the last 1-2 millenia based on sediment
% % fluxes from Lupker et al. (2012B) and Dingle et al. (2017)
% X_Him=0.65;   %relative contribution Himalayan flux after dissolution X_Him=Him/(Him+FP) 
% t=50; %maximum 
% %Provenanace effect - mixing of TH and LH 
% for i=1:101 %mixing proportions for TH/(TH+LH)input into the floodplain 
%     Trans_t=t*(i-1)/100; %Varying residance time from 0-10 time units
%     Him_input(i,:)=mix(X_TH,TH,LH); %calculates mineral and isotopic properties of mixed himalayan detrital input
%     Him_input_diss(i,:)=Him_input(i,:);
%     Him_input_diss(i,4)=Him_input(i,4)-cal_diss*Trans_t;
%     Him_input_diss(i,5)=Him_input(i,5)-dol_diss*Trans_t;
%     
%         
%     if Him_input_diss(i,4)<0
%        Him_input_diss(i,4)=0;
%     end
%     if Him_input_diss(i,5)<0
%        Him_input_diss(i,5)=0;
%     end
%     
%     FP_output(i,:)=mix(X_Him,Him_input_diss(i,:),SEC); %Calculate final mixing ratio by addition of Secondary calcite
%     ratio(i)=FP_output(i,4)/(FP_output(i,4)+FP_output(i,5)); %calculate cal/(cal+dol) ratio
% end
% 
% figure (1)
% p1=plot(ratio,FP_output(:,3));
% hold on
% scatter(cal_carb_data_turb,TD47data_turb,'o');
% title('Varying Trans_t')
% ylabel('T\Delta_{47}')
% xlabel('cal/\Sigma carbonate')
% 
% % figure (2)
% % p2=plot(FP_output(:,1),FP_output(:,3));
% % hold on
% % scatter(d18Odata_turb,TD47data_turb,'o');
% % title('Varying Trans_t')
% % ylabel('TD47')
% % xlabel('d18O(permil VPDB)')
% % 
% % figure (3)
% % p3=plot(FP_output(:,2),FP_output(:,3));
% % hold on
% % scatter(d13Cdata_turb,TD47data_turb,'o');
% % title('Varying Trans_t')
% % ylabel('TD47')
% % xlabel('d13C(permil VPDB)')

