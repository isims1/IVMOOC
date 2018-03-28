library(shiny)
library(data.table)
library(ggplot2)
library(dplyr)
library(patentsview)
library(purrr)
library(visNetwork)
library(shinydashboard)
library(stringr)
library(scales)
library(magrittr)
library(treemap)
library(DT)
library(shinycssloaders)
library(leaflet)
library(leaflet.extras)



#source functions
source("Func_View_All_Data.R")
source("Func_Map_Vis.R")
source("Func_Network_Vis.R")
source("Func_Pull_Data.R")
source("Func_Vis_Circular.R")
source("Func_CPC_Treemap_Vis.R")

#load data
IN_patent_data_combined <- readRDS("IN_patent_data_combined.RDS")
IN_patent_data_unnested <- readRDS("IN_patent_data_unnested.RDS")
data_last_update <- readRDS("Last_Data_Update_Date.RDS")
