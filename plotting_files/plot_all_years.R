library(data.table)
library(ggplot2)
library(tidyverse)
library(stringr)

# funtion to read and bind all data files
read_and_bind = function(file,datkl){
  ff = read.csv(file,header=TRUE)
  scen = str_extract_all(file,"(?<=_).+(?=_)")
  tar = str_extract_all(file,"(?<=_).+(?=.csv)")
  ff$target = as.character(parse_number(as.character(tar[1])))
  ff$scenario = as.character(scen[1])
  datkl = rbind(datkl,ff)
  rm(ff)
  return(datkl)
}

# function to import and create scenario and target columns for all files in the list
importfun = function(list){
  datkl = read.csv(list[[1]],header = TRUE)
  scen = str_extract_all(list[[1]],"(?<=_).+(?=_)")
  tar = str_extract_all(list[[1]],"(?<=_).+(?=.csv)")
  datkl$target = as.character(parse_number(as.character(tar[1])))
  datkl$scenario = as.character(scen[1])
  if (length(list) >= 2) {
    for (f in list[2:length(list)]) {
      datkl = read_and_bind(f,datkl)
    }
  }
  return(datkl)
}

# function to rename technologies and imports
rename_fun = function(dat) {
  dat[dat=='HYE'] = 'hydroelectric'
  dat[dat=='PHO'] = 'photovoltaic'
  dat[dat=='WON'] = 'wind on shore'
  dat[dat=='WOF'] = 'wind of shore'
  dat[dat=='CSP'] = 'concentrated solar power'
  dat[dat=='CGC'] = 'combined gas cycle'
  dat[dat=='GEO'] = 'geothermic'
  dat[dat=='CPP'] = 'coal power plant'
  dat[dat=='NUC'] = 'nuclear'
  dat[dat=='PPS'] = 'pumped storage'
  dat[dat=='WTE'] = 'waste to energy'
  dat[dat=='IMPELC'] = 'electricity imports'
  dat[dat=='IMPNAT'] = 'natural gas'
  dat[dat=='IMPCOA'] = 'coalt'
  dat[dat=='IMPURA'] = 'uranium'
  dat[dat=='indep'] = 'independence'
  return(dat)
}

imports = c('IMPNAT','IMPCOA','IMPELC','IMPURA')
imports_own = c('IMPNAT','IMPCOA','IMPELC','IMPURA','OWNUBW')
techs = c('CPP','NUC','HYE','PPS','PHO','CGC','WTE','WON','WOF','CSP','GEO')
re = c('REL','REu')
tx = c('TXE','TXu')

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#940083", "#0072B2",
               "#D55E00", "#CC79A7", "#00446b", "#2ac712", "#ff0022", "#990018")
cbPalette2 <- c("#999999", "#E69F00", "#009E73", "#ff0022", "#CC79A7", "#0072B2",
                     "#D55E00", "#00c2cc", "#00446b", "#2ac712", "#ff0022", "#990018")

##################################################################
#                     ANNUAL EMISSIONS                          #
##################################################################

list_files = as.list(list.files(pattern = "annualEmissions", recursive = TRUE))
datEmi = importfun(list_files)
datEmi[datEmi=='indep'] = 'independence'
datEmi$target <- factor(datEmi$target, levels = c("5", "10", "15"))

pl_AnnEm <- ggplot(data = datEmi_plot |> filter(target == '10'),
                   aes(x = year, y = value)) +#, linetype = target)) +
  ggtitle('Annual Emissions') +
  ylab("Emissions Level [kT CO2/PJ] ") + xlab("Time [year]") +
  geom_line(aes(linetype = scenario)) +
  scale_linetype_manual(values=c("dashed", "solid"))+
  scale_color_brewer(palette="Dark2") +
  # scale_colour_manual(values=cbPalette) +
  geom_vline(xintercept = 2021, color = 'grey') +
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())
pl_AnnEm
ggsave(file='plots/newPlots/annual_emissions_10.png', plot = pl_AnnEm)

##################################################################
#                   ACCUMULATED ANNUAL DEMAND                    #
##################################################################

list_files = as.list(list.files(pattern = "accumulatedAnnualDemand_", recursive = TRUE))
datAccDem_ini = importfun(list_files)
datAccDem_ini$scenario <- NULL

options(dplyr.summarise.inform = FALSE)
tmp = datAccDem_ini %>% 
  group_by(year, target) %>% 
  summarise(value = sum(value))
tmp$fuel = 'all'
tmp$region = 'ITALY'
datAccDem_plot = rbind(datAccDem_ini,tmp)

pl_accDem <- ggplot() +

  geom_line(data = datAccDem_plot|> filter(target == '15' & fuel == 'all'),
          aes(x = year, y = value,  linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '15' & fuel == 'all'),
            aes(x = year, y = value)) +
  geom_line(data = datAccDem_plot|> filter(target == '10' & fuel == 'all'),
            aes(x = year, y = value, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '10' & fuel == 'all'),
             aes(x = year, y = value)) +
  geom_line(data = datAccDem_plot|> filter(target == '5' & fuel == 'all'),
            aes(x = year, y = value, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '5' & fuel == 'all'),
             aes(x = year, y = value)) + 
  
geom_line(data = datAccDem_plot|> filter(target == '15' & fuel == 'RE'),
          aes(x = year, y = value, color = target, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '15' & fuel == 'RE'),
             aes(x = year, y = value, color = target)) +
  geom_line(data = datAccDem_plot|> filter(target == '10' & fuel == 'RE'),
            aes(x = year, y = value, color = target, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '10' & fuel == 'RE'),
             aes(x = year, y = value, color = target)) +
  geom_line(data = datAccDem_plot|> filter(target == '5' & fuel == 'RE'),
            aes(x = year, y = value, color = target, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '5' & fuel == 'RE'),
             aes(x = year, y = value, color = target)) + 
  
geom_line(data = datAccDem_plot|> filter(target == '15' & fuel == 'TX'),
          aes(x = year, y = value, color = target, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '15' & fuel == 'TX'),
             aes(x = year, y = value, color = target)) +
  geom_line(data = datAccDem_plot|> filter(target == '10' & fuel == 'TX'),
            aes(x = year, y = value, color = target, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '10' & fuel == 'TX'),
             aes(x = year, y = value, color = target)) +
  geom_line(data = datAccDem_plot|> filter(target == '5' & fuel == 'TX'),
            aes(x = year, y = value, color = target, linetype = target)) +
  geom_point(data = datAccDem_plot|> filter(target == '5' & fuel == 'TX'),
             aes(x = year, y = value, color = target)) + 
  
  geom_vline(xintercept = 2027, color = 'grey') +
  geom_vline(xintercept = 2032, color = 'grey') +
  scale_color_brewer(palette="Dark2") + 
  geom_point() +
  ggtitle('Electricity Annual Demand') +
  ylab("Demand [PJ] ") + xlab("Time [year]") +
  scale_linetype_manual(values=c("dashed","dotted","solid"))+
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())

pl_accDem
ggsave(file='plots/demand/AnnualDemand_all.png', plot = pl_accDem)

##################################################################
#             TOTAL ANNUAL TECHNOLOGY ACTIVITY                   #
##################################################################

list_files = as.list(list.files(pattern = "annualTechnologyActivity_", recursive = TRUE))
datAct = importfun(list_files)

datAct_plot[datAct == 'EPS'] <- "0"
datAct_plot = rename_fun(datAct_plot)

pl_activity <- ggplot(data = datAct_plot |> filter(target == '15' & technology %in% techs)) +
  geom_line(aes(x = year, y = value, color = technology, linetype = scenario)) +
  scale_linetype_manual(values=c("dashed", "solid"))+
  scale_color_manual(values=cbPalette) +
  # scale_color_brewer(palette="Dark2") +
  ggtitle('Total Annual Technology Activity') +
  ylab("Activity [PJ]") + xlab("Time [year]") +
  geom_vline(xintercept = 2021, color = 'grey') +
  labs(linetype="scenario") + #color="imports", 
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())
pl_activity
ggsave(file='plots/newPlots/tech_activity_techs_10.png', plot = pl_activity)

##################################################################
#                  ENERGY PRODUCTION ANNUAL                      #
##################################################################

list_files = as.list(list.files(pattern = "productionByTechnologyAnnual_", recursive = TRUE))
datProdAnnual_ini = importfun(list_files)

renewables = c('HYE','PHO','WON','WOF','CSP','GEO','PPS')
non_renewables = c('CGC','CPP','NUC','WTE')

datProdAnnual = datProdAnnual |> filter(fuel == 'ELC' & target == '10' & technology %in% techs)
datProdAnnual = rename_fun(datProdAnnual)

pl_prodAnnual <- ggplot(data = datProdAnnual) +
  ggtitle('Annual Electricity production') +
  ylab("Production [PJ]") + xlab("Time [year]") +
  scale_colour_manual(values=cbPalette) +
  geom_line(aes(x = year, y = value, color = technology, linetype = scenario)) +
  scale_linetype_manual(values=c("dotted", "solid"))+
  geom_vline(xintercept = 2021, color = 'grey') +
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())
pl_prodAnnual
# ggsave(file='plots/newPlots2/annualtechproduction_10.png', plot = pl_prodAnnual)

##################################################################
#            HOURLY ELECTRICITY PRODUCTION                       #
##################################################################

list_files = as.list(list.files(pattern = "productionByTechnologyTimeslice_", recursive = TRUE))
datProdTechHourly = importfun(list_files)

maskfile = "mask_timesplit_hours.csv"
mask = read.csv(maskfile,header = TRUE)

specHourElProd = merge(datProdTechHourly,mask,by = 'timeslice')
specHourElProd_plot = subset(specHourElProd,year == '2022' & fuel == 'ELC' & technology == 'PHO')
pl_HourElectProd <- ggplot(data = specHourElProd_plot, # DATA
                           aes(x = hours, y = value, linetype = season)) +
  ggtitle('Hourly Electricity Production of Photovoltaic') +
  ylab("Demand [PJ]") + xlab("Hours [h]") +
  scale_linetype_manual(values=c('dashed',"dotted", "solid"))+
  geom_line()+
  scale_color_brewer(palette="Dark2") + 
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())

pl_HourElectProd
ggsave(file='plots/production/hourElectricityProduction_PHO.png', plot = pl_HourElectProd)


##################################################################
#                         RESIDUAL CAPACITY                       #
##################################################################

list_files = as.list(list.files(pattern = "residualCapacity_", recursive = TRUE))
datResCap = importfun(list_files)
datResCap = rename_fun(datResCap)

pl_resCap <- ggplot(data = datResCap |> filter(technology != 'TXE'), # DATA
                           aes(x = year, y = value, color = technology)) +
  geom_line() +
  ggtitle('Residual Capacity') +
  ylab("Capacity [GW]") + xlab("Year") +
  scale_colour_manual(values=cbPalette2) +
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())

pl_resCap
ggsave(file='plots/newPlots/residualCapacity.png', plot = pl_resCap)

##################################################################
#                     HOURLY DEMAND                              #
##################################################################

csv_specDemProfile = "demand/specifiedDemandProfile.csv"
dat = read.csv(csv_specDemProfile, header = TRUE)

maskfile = "mask_timesplit_hours.csv"
mask = read.csv(maskfile,header = TRUE)

specDemProfile = merge(dat,mask,by = 'timeslice')
specDemProfile = subset(specDemProfile,year == '2020')

pl_spec_hour_demand <- ggplot(data = specDemProfile, # DATA
                              aes(x = hours, y = value, color = season)) +
  ggtitle('Hourly demand') +
  ylab("Demand [PJ]") + xlab("Hours [h]") +
  scale_color_brewer(palette="Dark2") + 
  geom_line() +
  theme_bw() +
  theme(aspect.ratio = 0.8,
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        legend.background=element_blank())

pl_spec_hour_demand
ggsave(file='plots/hourlyDemandProfile/hour_demand_profile.png', plot = pl_spec_hour_demand)
