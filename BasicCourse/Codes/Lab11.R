######################################
####       CH11 - Packages        ####
######################################

#### CH 11.1 : Introduction & Package DIY ####
# see steps in textbook !

#### CH 11.1 : Introduction & Package DIY : Introduction ####
# see steps in textbook !

#### CH 11.1 : Introduction & Package DIY : Package Structure ####
# see steps in textbook !

#### CH 11.1 : Introduction & Package DIY : Start making Package ####
# see steps in textbook !

#### ___________________________________________________________ ####
#### CH 11.2 : Installed , Import and Enable pacakge ####

#### CH 11.2 : Installed , Import and Enable pacakge : CRAN ####
https://cran.r-project.org/

#### CH 11.2 : Installed , Import and Enable pacakge : GUI Import ####

#### CH 11.2 : Installed , Import and Enable pacakge : Code Import ####
install.packages("xxxx")
#### CH 11.2 : Installed , Import and Enable pacakge : Enable Package ####
library(xxxx)
require(xxxx)

#### CH 11.2 : Installed , Import and Enable pacakge : Disable Package ####
detach("package:Test02")
remove.pacakges(Test02)
remove.pacakges("Test02")

#### CH 11.2 : Installed , Import and Enable pacakge : Advanced Import ####
rm(list=ls())
load.libraries <- c('dplyr','ggplot2','readr','lubridate','plotly')
install.lib <- load.libraries[!load.libraries %in% installed.packages()]
for(libs in install.lib) install.packages(libs, dependences = TRUE)
sapply(load.libraries, require, character = TRUE)

#### ___________________________________________________________ ####
#### Appendix : Library vs. Require ####

# discrepency between library and require (use ctrl+shift+c to comment/uncomment codes below )
for(i in 1:5){
  x = i*7 ; print(x)
  #library(okok)
  require(okok) ; cat("Finished!!")
}

