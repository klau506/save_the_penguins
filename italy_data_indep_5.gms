$offlisting
* UTOPIA_DATA.GMS - specify Utopia Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
* OSEMOSYS 2016.08.01 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS 2020.04.13 reformatting by Giacomo Marangoni
* OSEMOSYS 2020.04.15 change yearsplit by Giacomo Marangoni

$offlisting

* OSEMOSYS 2016.08.01
* Open Source energy Modeling SYStem
*
*#      Based on ITALY version 5: BASE - Utopia Base Model
*#      Energy and demands in PJ/a
*#      Power plants in GW
*#      Investment and Fixed O&M Costs: Power plant: Million $ / GW (//$/kW)
*#      Investment  and Fixed O&M Costs Costs: Other plant costs: Million $/PJ/a
*#      Variable O&M (& Import) Costs: Million $ / PJ (//$/GJ)
*#
*#****************************************

$eolcom #

*------------------------------------------------------------------------	
* Sets       
*------------------------------------------------------------------------


$offlisting
set     YEAR    / 2018*2027 /;
set     TECHNOLOGY      /
        CPP 'Coal power plants'
        NUC 'Nuclear power plants'
        HYE 'Hydroelectric power plants'
        PPS 'Pumped storage'
        PHO 'Photovoltaic'
        CGC 'Combined gas cycle'
        WTE 'Waste to energy'
        WON 'Wind onshore'
        WOF 'Wind offshore'
        CSP 'Concentrated solar power'
        GEO 'Geothermal'

        IMPELC 'Electricity imports'
        IMPNAT 'Natural gas imports'
        IMPCOA 'Coal imports'
        IMPURA 'Uranium imports'
        OWNUBW 'Urban waste own production'

        REL 'Residential + industrial electricity demand'
        TXE 'Personal vehicles - electric'

        REu 'Residential + industrial electricity - Unmet demand'
        TXu 'Personal transport - Unmet demand'
/;
set     TIMESLICE       /
        I1*I24 'Intermediate - hours'  
        S1*S24 'Summer - hours'
        W1*W24 'Winter - hours'
/;
set     FUEL    /
        ELC 'Electricity'
        NAT 'Natural gas'
        COA 'Coal'
        URN 'Uranium'
        UBW 'Urban waste'

        RE 'Demand for residential electricity'
        TX 'Demand for personal transport'
/;
set     EMISSION        / CO2 /;
set     MODE_OF_OPERATION       / 1, 2 /;
set     REGION  / ITALY /;
set     SEASON / 1, 2, 3 /;
set     DAYTYPE / 1 /;
set     DAILYTIMEBRACKET / 1*24 /;
set     STORAGE / DAM /;



*------------------------------------------------------------------------	
* Parameters - Global
*------------------------------------------------------------------------


parameter YearSplit(l,y) /
  (I1*I24).(2018*2027)  0.0208333333
  (S1*S24).(2018*2027)  0.0104166667
  (W1*W24).(2018*2027)  0.0104166667  
/;

DiscountRate(r) = 0.05;

DaySplit(y,lh) = 1/(24*365);

parameter Conversionls(l,ls) /
  (I1*I24).2  1
  (S1*S24).3  1
  (W1*W24).1  1
/;

parameter Conversionld(l,ld) /
  (I1*I24).1     1  
  (S1*S24).1     1  
  (W1*W24).1     1
/;

parameter Conversionlh(l,lh) /
  I1.1    1
  I2.2    1
  I3.3    1
  I4.4    1
  I5.5    1
  I6.6    1
  I7.7    1
  I8.8    1
  I9.9    1
  I10.10    1
  I11.11    1
  I12.12    1
  I13.13    1
  I14.14    1
  I15.15    1
  I16.16    1
  I17.17    1
  I18.18    1
  I19.19    1
  I20.20    1
  I21.21    1
  I22.22    1
  I23.23    1
  I24.24    1
  
  S1.1    1
  S2.2    1
  S3.3    1
  S4.4    1
  S5.5    1
  S6.6    1
  S7.7    1
  S8.8    1
  S9.9    1
  S10.10    1
  S11.11    1
  S12.12    1
  S13.13    1
  S14.14    1
  S15.15    1
  S16.16    1
  S17.17    1
  S18.18    1
  S19.19    1
  S20.20    1
  S21.21    1
  S22.22    1
  S23.23    1
  S24.24    1

  W1.1    1
  W2.2    1
  W3.3    1
  W4.4    1
  W5.5    1
  W6.6    1
  W7.7    1
  W8.8    1
  W9.9    1
  W10.10    1
  W11.11    1
  W12.12    1
  W13.13    1
  W14.14    1
  W15.15    1
  W16.16    1
  W17.17    1
  W18.18    1
  W19.19    1
  W20.20    1
  W21.21    1
  W22.22    1
  W23.23    1
  W24.24    1
/;

DaysInDayType(y,ls,ld) = 7;

TradeRoute(r,rr,f,y) = 0;

DepreciationMethod(r) = 1;


*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------

parameter EnergyConsumptionStartingYear 'Annual electric energy demand in 2018 [PJ*h]' / 1021.5108 /;

parameter EnergyConsumptionLinearGrowth1 'Linear electric energy demand growth' / 14 /;

SpecifiedAnnualDemand(r,'RE',y) = EnergyConsumptionStartingYear + EnergyConsumptionLinearGrowth1*(y.val - 2018);



parameter SpecifiedDemandProfile(r,f,l,y) /
  ITALY.RE.I1.(2018*2027)    0.011171
  ITALY.RE.I2.(2018*2027)    0.01046
  ITALY.RE.I3.(2018*2027)    0.010078
  ITALY.RE.I4.(2018*2027)    0.009945
  ITALY.RE.I5.(2018*2027)    0.010035
  ITALY.RE.I6.(2018*2027)    0.010586
  ITALY.RE.I7.(2018*2027)    0.012072
  ITALY.RE.I8.(2018*2027)    0.01382
  ITALY.RE.I9.(2018*2027)    0.015411
  ITALY.RE.I10.(2018*2027)    0.016102
  ITALY.RE.I11.(2018*2027)    0.01619
  ITALY.RE.I12.(2018*2027)    0.016173
  ITALY.RE.I13.(2018*2027)    0.015466
  ITALY.RE.I14.(2018*2027)    0.015199
  ITALY.RE.I15.(2018*2027)    0.01542
  ITALY.RE.I16.(2018*2027)    0.015478
  ITALY.RE.I17.(2018*2027)    0.015532
  ITALY.RE.I18.(2018*2027)    0.015472
  ITALY.RE.I19.(2018*2027)    0.015562
  ITALY.RE.I20.(2018*2027)    0.015989
  ITALY.RE.I21.(2018*2027)    0.015746
  ITALY.RE.I22.(2018*2027)    0.014802
  ITALY.RE.I23.(2018*2027)    0.013481
  ITALY.RE.I24.(2018*2027)    0.012288
  
  ITALY.RE.S1.(2018*2027) 0.01181512
  ITALY.RE.S2.(2018*2027) 0.011079601
  ITALY.RE.S3.(2018*2027) 0.010602024
  ITALY.RE.S4.(2018*2027) 0.010329509
  ITALY.RE.S5.(2018*2027) 0.010266638
  ITALY.RE.S6.(2018*2027) 0.010567469
  ITALY.RE.S7.(2018*2027) 0.01093752
  ITALY.RE.S8.(2018*2027) 0.011983696
  ITALY.RE.S9.(2018*2027) 0.013384081
  ITALY.RE.S10.(2018*2027) 0.014308876
  ITALY.RE.S11.(2018*2027) 0.014803289
  ITALY.RE.S12.(2018*2027) 0.015144471
  ITALY.RE.S13.(2018*2027) 0.015095399
  ITALY.RE.S14.(2018*2027) 0.014999519
  ITALY.RE.S15.(2018*2027) 0.015015748
  ITALY.RE.S16.(2018*2027) 0.015007744
  ITALY.RE.S17.(2018*2027) 0.015064488
  ITALY.RE.S18.(2018*2027) 0.015059686
  ITALY.RE.S19.(2018*2027) 0.014865553
  ITALY.RE.S20.(2018*2027) 0.014967836
  ITALY.RE.S21.(2018*2027) 0.015254205
  ITALY.RE.S22.(2018*2027) 0.014796168
  ITALY.RE.S23.(2018*2027) 0.013740167
  ITALY.RE.S24.(2018*2027) 0.012653585

  ITALY.RE.W1.(2018*2027) 0.011231507
  ITALY.RE.W2.(2018*2027) 0.010525132
  ITALY.RE.W3.(2018*2027) 0.010092266
  ITALY.RE.W4.(2018*2027) 0.009922678
  ITALY.RE.W5.(2018*2027) 0.009993902
  ITALY.RE.W6.(2018*2027) 0.010632604
  ITALY.RE.W7.(2018*2027) 0.01244142
  ITALY.RE.W8.(2018*2027) 0.014503598
  ITALY.RE.W9.(2018*2027) 0.016033552
  ITALY.RE.W10.(2018*2027) 0.016834629
  ITALY.RE.W11.(2018*2027) 0.016984088
  ITALY.RE.W12.(2018*2027) 0.016934023
  ITALY.RE.W13.(2018*2027) 0.016218798
  ITALY.RE.W14.(2018*2027) 0.01581377
  ITALY.RE.W15.(2018*2027) 0.015892594
  ITALY.RE.W16.(2018*2027) 0.016035208
  ITALY.RE.W17.(2018*2027) 0.016387871
  ITALY.RE.W18.(2018*2027) 0.017190696
  ITALY.RE.W19.(2018*2027) 0.017424977
  ITALY.RE.W20.(2018*2027) 0.017193088
  ITALY.RE.W21.(2018*2027) 0.016306766
  ITALY.RE.W22.(2018*2027) 0.015135804
  ITALY.RE.W23.(2018*2027) 0.013694094
  ITALY.RE.W24.(2018*2027) 0.012359211
/;

parameter AccumulatedAnnualDemand(r,f,y) /
  ITALY.TX.2018 41.74
  ITALY.TX.2019 42.48
  ITALY.TX.2020 43.20
  ITALY.TX.2021 43.63
  ITALY.TX.2022 44.24
  ITALY.TX.2023 45.18
  ITALY.TX.2024 46.76
  ITALY.TX.2025 48.60
/;
parameter IncreaseDemand1 'Linear electric energy demand growth of trasport' / 2.3 /;
AccumulatedAnnualDemand(r,'TX',y)$(y.val ge 2025) = AccumulatedAnnualDemand(r,'TX','2025') + IncreaseDemand1*(y.val - 2025);


*------------------------------------------------------------------------	
* Parameters - Performance       
*------------------------------------------------------------------------

parameter CapacityToActivityUnit(r,t) /
  ITALY.CPP  31.536
  ITALY.NUC  31.536
  ITALY.HYE  31.536
  ITALY.PPS  31.536
  ITALY.PHO  31.536
  ITALY.CGC  31.536
  ITALY.WTE  31.536
  ITALY.WON  31.536
  ITALY.WOF  31.536
  ITALY.CSP  31.536
  ITALY.GEO  31.536

  ITALY.TXE  18.3
/;
CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;

parameter CapacityFactor(r,t,l,y) /     # Capacity factor accounts also for renewables hourly fluctuations
  ITALY.PHO.I1.(2018*2027)    1e-9
  ITALY.PHO.I2.(2018*2027)    1e-9
  ITALY.PHO.I3.(2018*2027)    1e-9
  ITALY.PHO.I4.(2018*2027)    1e-9
  ITALY.PHO.I5.(2018*2027)    0.02
  ITALY.PHO.I6.(2018*2027)    0.115
  ITALY.PHO.I7.(2018*2027)    0.295
  ITALY.PHO.I8.(2018*2027)    0.415
  ITALY.PHO.I9.(2018*2027)    0.5
  ITALY.PHO.I10.(2018*2027)    0.535
  ITALY.PHO.I11.(2018*2027)    0.55
  ITALY.PHO.I12.(2018*2027)    0.515
  ITALY.PHO.I13.(2018*2027)    0.42
  ITALY.PHO.I14.(2018*2027)    0.32
  ITALY.PHO.I15.(2018*2027)    0.33
  ITALY.PHO.I16.(2018*2027)    0.145
  ITALY.PHO.I17.(2018*2027)    0.025
  ITALY.PHO.I18.(2018*2027)    1e-9
  ITALY.PHO.I19.(2018*2027)    1e-9
  ITALY.PHO.I20.(2018*2027)    1e-9
  ITALY.PHO.I21.(2018*2027)    1e-9
  ITALY.PHO.I22.(2018*2027)    1e-9
  ITALY.PHO.I23.(2018*2027)    1e-9
  ITALY.PHO.I24.(2018*2027)    1e-9
  
  ITALY.PHO.S1.(2018*2027)    1e-9
  ITALY.PHO.S2.(2018*2027)    1e-9
  ITALY.PHO.S3.(2018*2027)    1e-9
  ITALY.PHO.S4.(2018*2027)    1e-9
  ITALY.PHO.S5.(2018*2027)    0.04
  ITALY.PHO.S6.(2018*2027)    0.2
  ITALY.PHO.S7.(2018*2027)    0.38
  ITALY.PHO.S8.(2018*2027)    0.52
  ITALY.PHO.S9.(2018*2027)    0.63
  ITALY.PHO.S10.(2018*2027)    0.69
  ITALY.PHO.S11.(2018*2027)    0.695
  ITALY.PHO.S12.(2018*2027)    0.68
  ITALY.PHO.S13.(2018*2027)    0.62
  ITALY.PHO.S14.(2018*2027)    0.5
  ITALY.PHO.S15.(2018*2027)    0.35
  ITALY.PHO.S16.(2018*2027)    0.18
  ITALY.PHO.S17.(2018*2027)    0.04
  ITALY.PHO.S18.(2018*2027)    1e-9
  ITALY.PHO.S19.(2018*2027)    1e-9
  ITALY.PHO.S20.(2018*2027)    1e-9
  ITALY.PHO.S21.(2018*2027)    1e-9
  ITALY.PHO.S22.(2018*2027)    1e-9
  ITALY.PHO.S23.(2018*2027)    1e-9
  ITALY.PHO.S24.(2018*2027)    1e-9
  
  ITALY.PHO.W1.(2018*2027)    1e-9
  ITALY.PHO.W2.(2018*2027)    1e-9
  ITALY.PHO.W3.(2018*2027)    1e-9
  ITALY.PHO.W4.(2018*2027)    1e-9
  ITALY.PHO.W5.(2018*2027)    1e-9
  ITALY.PHO.W6.(2018*2027)    1e-9
  ITALY.PHO.W7.(2018*2027)    0.15
  ITALY.PHO.W8.(2018*2027)    0.35
  ITALY.PHO.W9.(2018*2027)    0.44
  ITALY.PHO.W10.(2018*2027)    0.51
  ITALY.PHO.W11.(2018*2027)    0.54
  ITALY.PHO.W12.(2018*2027)    0.52
  ITALY.PHO.W13.(2018*2027)    0.45
  ITALY.PHO.W14.(2018*2027)    0.33
  ITALY.PHO.W15.(2018*2027)    0.15
  ITALY.PHO.W16.(2018*2027)    1e-9
  ITALY.PHO.W17.(2018*2027)    1e-9
  ITALY.PHO.W18.(2018*2027)    1e-9
  ITALY.PHO.W19.(2018*2027)    1e-9
  ITALY.PHO.W20.(2018*2027)    1e-9
  ITALY.PHO.W21.(2018*2027)    1e-9
  ITALY.PHO.W22.(2018*2027)    1e-9
  ITALY.PHO.W23.(2018*2027)    1e-9
  ITALY.PHO.W24.(2018*2027)    1e-9

  ITALY.WON.(I1*I24).(2018*2027) 0.25
  ITALY.WON.(S1*S24).(2018*2027) 0.15        
  ITALY.WON.(W1*W24).(2018*2027) 0.33

  ITALY.CSP.(I1*I24).(2018*2027) 0.45        
  ITALY.CSP.(S1*S24).(2018*2027) 0.60       
  ITALY.CSP.(W1*W24).(2018*2027) 0.30
/;
CapacityFactor(r,'CPP',l,y) = 0.9;
CapacityFactor(r,'NUC',l,y) = 0.9;
CapacityFactor(r,'HYE',l,y) = 0.25;
CapacityFactor(r,'PPS',l,y) = 0.17;
CapacityFactor(r,'CGC',l,y) = 0.70;
CapacityFactor(r,'WTE',l,y) = 0.91;
CapacityFactor(r,'WOF',l,y) = 0.4;
CapacityFactor(r,'GEO',l,y) = 0.63;
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) = 0) = 1;

AvailabilityFactor(r,t,y) = 1;

parameter OperationalLife(r,t) /
  ITALY.CPP  40
  ITALY.NUC  50
  ITALY.HYE  100
  ITALY.PPS  100
  ITALY.PHO  30
  ITALY.CGC  27.5
  ITALY.WTE  15
  ITALY.WON  20
  ITALY.WOF  15
  ITALY.GEO  30
  ITALY.CSP  30

  ITALY.TXE  15
/;
OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1e15;

parameter ResidualCapacity(r,t,y) /
  ITALY.CPP.2018  0.3
  ITALY.HYE.2018  18.94
  ITALY.PPS.2018  4.33
  ITALY.PHO.2018  20.108
  ITALY.CGC.2018  55.9986
  ITALY.WTE.2018  0.402
  ITALY.WON.2018  10.265
  ITALY.WOF.2018  0
  ITALY.CSP.2018  0
  ITALY.GEO.2018  0.5945
  ITALY.TXE.2018  0.361
/;
ResidualCapacity(r,'CGC',y) = ResidualCapacity(r,'CGC','2018') * (1 - (y.val-2018)/(OperationalLife(r,'CGC')));
ResidualCapacity(r,'WTE',y) = ResidualCapacity(r,'WTE','2018') * (1 - (y.val-2018)/(OperationalLife(r,'WTE')));
ResidualCapacity(r,'GEO',y) = ResidualCapacity(r,'GEO','2018') * (1 - (y.val-2018)/(OperationalLife(r,'GEO')));
ResidualCapacity(r,'CPP',y) = ResidualCapacity(r,'CPP','2018') * (1 - (y.val-2018)/(OperationalLife(r,'CPP')));
ResidualCapacity(r,'HYE',y) = ResidualCapacity(r,'HYE','2018') * (1 - (y.val-2018)/(OperationalLife(r,'HYE')));
ResidualCapacity(r,'PPS',y) = ResidualCapacity(r,'PPS','2018') * (1 - (y.val-2018)/(OperationalLife(r,'PPS')));
ResidualCapacity(r,'PHO',y) = ResidualCapacity(r,'PHO','2018') * (1 - (y.val-2018)/(OperationalLife(r,'PHO')));
ResidualCapacity(r,'WON',y) = ResidualCapacity(r,'WON','2018') * (1 - (y.val-2018)/(OperationalLife(r,'WON')));
ResidualCapacity(r,'WOF',y) = ResidualCapacity(r,'WOF','2018') * (1 - (y.val-2018)/(OperationalLife(r,'WOF')));
ResidualCapacity(r,'CSP',y) = ResidualCapacity(r,'CSP','2018') * (1 - (y.val-2018)/(OperationalLife(r,'CSP')));
ResidualCapacity(r,'TXE',y) = ResidualCapacity(r,'TXE','2018') * (1 - (y.val-2018)/(OperationalLife(r,'TXE')));
ResidualCapacity(r,t,y)$(ResidualCapacity(r,t,y) le 0) = 0;     # To avoid negative residual capacities

ResidualCapacity(r,'REL',y) = 0;
ResidualCapacity(r,'NUC',y) = 0;


parameter InputActivityRatio(r,t,f,m,y) /
  ITALY.CPP.COA.1.(2018*2027)  2.22
  ITALY.NUC.URN.1.(2018*2027)  1
  ITALY.PPS.ELC.2.(2018*2027)  1.3889
  ITALY.CGC.NAT.1.(2018*2027)  1.56
  ITALY.WTE.UBW.1.(2018*2027)  3.33
  ITALY.REL.ELC.1.(2018*2027)  1
  ITALY.TXE.ELC.1.(2018*2027)  1
/;

parameter OutputActivityRatio(r,t,f,m,y) /
  ITALY.CPP.ELC.1.(2018*2027)  1
  ITALY.NUC.ELC.1.(2018*2027)  1
  ITALY.HYE.ELC.1.(2018*2027)  1
  ITALY.PPS.ELC.1.(2018*2027)  1
  ITALY.PHO.ELC.1.(2018*2027)  1
  ITALY.CGC.ELC.1.(2018*2027)  1
  ITALY.WTE.ELC.1.(2018*2027)  1
  ITALY.WON.ELC.1.(2018*2027)  1
  ITALY.WOF.ELC.1.(2018*2027)  1
  ITALY.CSP.ELC.1.(2018*2027)  1
  ITALY.GEO.ELC.1.(2018*2027)  1

  ITALY.IMPELC.ELC.1.(2018*2027)  1
  ITALY.IMPNAT.NAT.1.(2018*2027)  1
  ITALY.IMPCOA.COA.1.(2018*2027)  1
  ITALY.IMPURA.URN.1.(2018*2027)  1
  ITALY.OWNUBW.UBW.1.(2018*2027)  1

  ITALY.REL.RE.1.(2018*2027)   1
  ITALY.REU.RE.1.(2018*2027)   1
  ITALY.TXE.TX.1.(2018*2027)   1
  ITALY.TXU.TX.1.(2018*2027)   1
/;


*------------------------------------------------------------------------	
* Parameters - Technology costs       
*------------------------------------------------------------------------

parameter CapitalCost /
  ITALY.CPP.(2018*2027)  3121.64
  ITALY.NUC.(2018*2027)  7388.074
  ITALY.HYE.(2018*2027)  2500
  ITALY.PPS.(2018*2027)  900
  ITALY.CGC.(2018*2027)  1053.7
  ITALY.WTE.(2018*2027)  5830
  ITALY.GEO.(2018*2027)  6662.417

  ITALY.PHO.2018 1762.43
  ITALY.PHO.2019 1762.43
  ITALY.PHO.2020 1762.43
  ITALY.PHO.2021 1677.411
  ITALY.PHO.2022 1592.393
  ITALY.PHO.2023 1507.37
  ITALY.PHO.2024 1422.356
  ITALY.PHO.2025 1337.338
  ITALY.PHO.2026 1252.31
  ITALY.PHO.2027 1167.30

  ITALY.WON.2018 1436
  ITALY.WON.2019 1436
  ITALY.WON.2020 1391.8
  ITALY.WON.2021 1347.636
  ITALY.WON.2022 1303.45
  ITALY.WON.2023 1259.27
  ITALY.WON.2024 1215.19
  ITALY.WON.2025 1170.9
  ITALY.WON.2026 1126.72
  ITALY.WON.2027 1082.54

  ITALY.WOF.2018 3592.87 
  ITALY.WOF.2019 3592.87 
  ITALY.WOF.2020 3592.87 
  ITALY.WOF.2021 3392.95 
  ITALY.WOF.2022 3230.56 
  ITALY.WOF.2023 3091.53 
  ITALY.WOF.2024 2968.63 
  ITALY.WOF.2025 2857.51 
  ITALY.WOF.2026 2755.41 
  ITALY.WOF.2027 2660.41

  ITALY.CSP.2018 6781.008 
  ITALY.CSP.2019 6781.008 
  ITALY.CSP.2020 6572.586 
  ITALY.CSP.2021 6306.999 
  ITALY.CSP.2022 6019.327 
  ITALY.CSP.2023 5759.115 
  ITALY.CSP.2024 5525.026 
  ITALY.CSP.2025 5317.726 
  ITALY.CSP.2026 5129.878 
  ITALY.CSP.2027 4966.146

  ITALY.IMPELC.(2018*2027)  0
  ITALY.IMPNAT.(2018*2027)  0
  ITALY.IMPCOA.(2018*2027)  0
  ITALY.IMPURA.(2018*2027)  0
  ITALY.OWNUBW.(2018*2027)  0

  ITALY.REL.(2018*2027)  0
  ITALY.REu.(2018*2027)  0
  
  ITALY.TXE.2018  1725
  ITALY.TXE.2019  1700
  ITALY.TXE.2020  1675
  ITALY.TXE.2021  1650
  ITALY.TXE.2022  1625
  ITALY.TXE.2023  1600
  ITALY.TXE.2024  1575
  ITALY.TXE.2025  1550
  ITALY.TXE.2026  1525
  ITALY.TXE.2027  1500
  
  ITALY.TXu.(2018*2027)  0
/;

parameter VariableCost(r,t,m,y) /
  ITALY.CPP.1.(2018*2027) 2.074166667
  ITALY.NUC.1.(2018*2027) 0.620666667
  ITALY.CGC.1.(2018*2027) 0.459166667
  ITALY.WTE.1.(2018*2027) 2.074166667
  ITALY.GEO.1.(2018*2027) 3.855910694
  
  ITALY.IMPELC.1.(2018*2027) 22.22222222
  ITALY.IMPNAT.1.(2018*2027) 12.00694444
  ITALY.IMPCOA.1.(2018*2027) 4.620694444
  ITALY.IMPURA.1.(2018*2027) 2.462083333
  
  ITALY.OWNUBW.1.(2018*2027) 0

  ITALY.REU.1.(2018*2027)  1e15
  ITALY.TXU.1.(2018*2027)  1e15
/;
VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

parameter FixedCost /
  ITALY.CPP.(2018*2027)  96.200 
  ITALY.NUC.(2018*2027)  144.972
  ITALY.HYE.(2018*2027)  60.097
  ITALY.PPS.(2018*2027)  30
  ITALY.CGC.(2018*2027)  61.845 
  ITALY.WTE.(2018*2027)  9.139

  ITALY.PHO.2018 21.7436 
  ITALY.PHO.2019 22.2262 
  ITALY.PHO.2020 21.5745 
  ITALY.PHO.2021 20.92565 
  ITALY.PHO.2022 20.2787 
  ITALY.PHO.2023 19.63365 
  ITALY.PHO.2024 18.99145 
  ITALY.PHO.2025 18.35115 
  ITALY.PHO.2026 17.71275 
  ITALY.PHO.2027 17.07625

  ITALY.WON.2018 43.3
  ITALY.WON.2019 43.0
  ITALY.WON.2020 42.632 
  ITALY.WON.2021 42.264 
  ITALY.WON.2022 41.895 
  ITALY.WON.2023 41.527 
  ITALY.WON.2024 41.159 
  ITALY.WON.2025 40.791 
  ITALY.WON.2026 40.423 
  ITALY.WON.2027 40.055
      
  ITALY.WOF.2018 119.000 
  ITALY.WOF.2019 118.461 
  ITALY.WOF.2020 111.496 
  ITALY.WOF.2021 106.155 
  ITALY.WOF.2022 102.722 
  ITALY.WOF.2023 99.590 
  ITALY.WOF.2024 96.942 
  ITALY.WOF.2025 94.648 
  ITALY.WOF.2026 92.625 
  ITALY.WOF.2027 90.185

  ITALY.GEO.2018 139.000 
  ITALY.GEO.2019 138.007 
  ITALY.GEO.2020 137.058 
  ITALY.GEO.2021 136.110 
  ITALY.GEO.2022 135.162 
  ITALY.GEO.2023 134.214 
  ITALY.GEO.2024 133.265 
  ITALY.GEO.2025 132.317 
  ITALY.GEO.2026 131.369 
  ITALY.GEO.2027 130.420

  ITALY.CSP.2018 66.000 
  ITALY.CSP.2019 65.612 
  ITALY.CSP.2020 65.612 
  ITALY.CSP.2021 65.612 
  ITALY.CSP.2022 63.927 
  ITALY.CSP.2023 62.242 
  ITALY.CSP.2024 60.557 
  ITALY.CSP.2025 58.872 
  ITALY.CSP.2026 57.187 
  ITALY.CSP.2027 55.502

  ITALY.REL.(2018*2027)  9.46
  ITALY.TXE.(2018*2027)  100
/;

*------------------------------------------------------------------------	
* Parameters - Storage       
*------------------------------------------------------------------------

parameter TechnologyToStorage(r,m,t,s) /
  ITALY.2.PPS.DAM  1
/;

parameter TechnologyFromStorage(r,m,t,s) /
  ITALY.1.PPS.DAM  1
/;

StorageLevelStart(r,s) = 999;

StorageMaxChargeRate(r,s) = 99;

StorageMaxDischargeRate(r,s) = 99;

MinStorageCharge(r,s,y) = 0;

OperationalLifeStorage(r,s) = 99;

CapitalCostStorage(r,s,y) = 0;

ResidualStorageCapacity(r,s,y) = 999;



*------------------------------------------------------------------------	
* Parameters - Capacity and investment constraints       
*------------------------------------------------------------------------

CapacityOfOneTechnologyUnit(r,t,y) = 0;

parameter TotalAnnualMaxCapacity /
  ITALY.PPS.(2018*2027)  1e+3
  ITALY.NUC.(2018*2027)  1e-5
  ITALY.HYE.(2018*2027)  1e+3
  ITALY.PHO.(2018*2027)  1e+3
  ITALY.CGC.(2018*2027)  1e+3
  ITALY.WTE.(2018*2027)  1e+3
  ITALY.WON.(2018*2027)  1e+3
  ITALY.WOF.(2018*2027)  1e+3
  ITALY.CPP.(2018*2027)  1e+3
  ITALY.CSP.(2018*2027)  0.5
  ITALY.GEO.(2018*2027)  0.8
/;
TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 1e15;

TotalAnnualMinCapacity(r,t,y) = 0;

parameter TotalAnnualMaxCapacityInvestment(r,t,y) /
  ITALY.PPS.(2018*2027)  0.1
  ITALY.NUC.(2018*2027)  1e-5
  ITALY.HYE.(2018*2027)  1
  ITALY.CGC.(2018*2027)  1e-5
  ITALY.WTE.(2018*2027)  1
  ITALY.CPP.(2018*2027)  1e-5
  ITALY.GEO.(2018*2027)  0.2
  
  ITALY.PHO.(2018*2021)  10
  ITALY.PHO.(2022*2024)  12
  ITALY.PHO.(2025*2027)  15
 
  ITALY.WON.(2018*2021)  5
  ITALY.WON.(2022*2024)  7
  ITALY.WON.(2025*2027)  9
  
  ITALY.WOF.(2018*2021)  0.1
  ITALY.WOF.(2022*2023)  0.5
  ITALY.WOF.(2024*2027)  1

  ITALY.CSP.(2018*2021)  0.2
  ITALY.CSP.(2022*2023)  0.3
  ITALY.CSP.(2024*2027)  0.7
/;
TotalAnnualMaxCapacityInvestment(r,t,y)$(TotalAnnualMaxCapacityInvestment(r,t,y)=0) = 1e15;     # All others technologies have no limit

parameter TotalAnnualMinCapacityInvestment(r,t,y)/
  ITALY.PHO.(2022*2024)   5
  ITALY.PHO.(2025*2027)   8
  ITALY.WON.(2018*2027)   0.02
  ITALY.WOF.(2022*2027)   0.5
/;


*------------------------------------------------------------------------	
* Parameters - Activity constraints       
*------------------------------------------------------------------------

parameter TotalTechnologyAnnualActivityUpperLimit(r,t,y) /
  ITALY.OWNUBW.(2018*2027)  10

  ITALY.IMPELC.2027   1e-9  
  ITALY.IMPCOA.2027   1e-9
  ITALY.IMPNAT.2027   250

  ITALY.PHO.2018      80.28
  ITALY.PHO.2019      85.32
  ITALY.PHO.2020      89.64
  ITALY.PHO.2021      93.654
  
  ITALY.WON.2018      63.36
  ITALY.WON.2019      72.72
  ITALY.WON.2020      89.64
  ITALY.WON.2021      78.098
  
  ITALY.HYE.2018      153.2
  ITALY.HYE.2019      156.68
  ITALY.HYE.2020      151.36
  ITALY.HYE.2021      150.045
  
  ITALY.CGC.2018      700
  ITALY.CGC.2019      674.19
  ITALY.CGC.2020      653.506
  ITALY.CGC.2021      632.966

  ITALY.IMPELC.2018   169
  ITALY.IMPELC.2019   158
  ITALY.IMPELC.2020   143
  ITALY.IMPELC.2021   158

  ITALY.IMPCOA.2018   317
  ITALY.IMPCOA.2019   275
  ITALY.IMPCOA.2020   193
/;
TotalTechnologyAnnualActivityUpperLimit(r,t,y)$(TotalTechnologyAnnualActivityUpperLimit(r,t,y)=0) = 1e15;

parameter TotalTechnologyAnnualActivityLowerLimit(r,t,y) /  #to force historical trend
  ITALY.PHO.2018      80.28
  ITALY.PHO.2019      85.32
  ITALY.PHO.2020      89.64
  ITALY.PHO.2021      93.654
  
  ITALY.WON.2018      63.36
  ITALY.WON.2019      72.72
  ITALY.WON.2020      89.64
  ITALY.WON.2021      78.098
  
  ITALY.HYE.2018      153.2
  ITALY.HYE.2019      156.68
  ITALY.HYE.2020      151.36
  ITALY.HYE.2021      150.045
  
  ITALY.CGC.2018      700
  ITALY.CGC.2019      674.19
  ITALY.CGC.2020      653.506
  ITALY.CGC.2021      632.966

  ITALY.IMPELC.2018   169
  ITALY.IMPELC.2019   158
  ITALY.IMPELC.2020   143
  ITALY.IMPELC.2021   158

  ITALY.IMPCOA.2018   317
  ITALY.IMPCOA.2019   275
  ITALY.IMPCOA.2020   193
/;

TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 1e15;

TotalTechnologyModelPeriodActivityLowerLimit(r,t) = 0;


*------------------------------------------------------------------------	
* Parameters - Reserve margin
*-----------------------------------------------------------------------

parameter ReserveMarginTagTechnology(r,t,y) /
  ITALY.CPP.(2018*2027)  1
  ITALY.NUC.(2018*2027)  1
  ITALY.HYE.(2018*2027)  1
  ITALY.PPS.(2018*2027)  1
  ITALY.PHO.(2018*2027)  1
  ITALY.CGC.(2018*2027)  1
  ITALY.WTE.(2018*2027)  1
  ITALY.WON.(2018*2027)  1
  ITALY.WOF.(2018*2027)  1
  ITALY.CSP.(2018*2027)  1
  ITALY.GEO.(2018*2027)  1
/;

parameter ReserveMarginTagFuel(r,f,y) /
  ITALY.ELC.(2018*2027)  1
/;

parameter ReserveMargin(r,y) /
  ITALY.(2018*2027)  1.18
/;


*------------------------------------------------------------------------	
* Parameters - RE Generation Target       
*------------------------------------------------------------------------

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Emissions       
*------------------------------------------------------------------------

parameter EmissionActivityRatio(r,t,e,m,y) /
  ITALY.GEO.CO2.1.(2018*2027) 42.58
  ITALY.HYE.CO2.1.(2018*2027) 36
  ITALY.PHO.CO2.1.(2018*2027) 108
  ITALY.WON.CO2.1.(2018*2027) 36
  ITALY.WOF.CO2.1.(2018*2027) 115.2
  ITALY.NUC.CO2.1.(2018*2027) 18.468
  ITALY.CSP.CO2.1.(2018*2027) 129.6
  ITALY.WTE.CO2.1.(2018*2027) 2088
  ITALY.CGC.CO2.1.(2018*2027) 1562.4
  ITALY.CPP.CO2.1.(2018*2027) 3682.8
  ITALY.PPS.CO2.1.(2018*2027) 0 #the emissions are accounted in the hydroelectric
  ITALY.TXE.CO2.1.(2018*2027) 0
/;

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 1e15;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 1e15;
