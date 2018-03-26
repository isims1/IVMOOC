library(shiny)
library(dplyr)
library(patentsview)
library(purrr)
library(visNetwork)
library(shinydashboard)

#source functions
source("Func_View_All_Data.R")
source("Func_Network_Vis.R")
source("Func_Pull_Data.R")

#load data
IN_patent_data_combined <- readRDS("IN_patent_data_combined.RDS")
IN_patent_data_unnested <- readRDS("IN_patent_data_unnested.RDS")
data_last_update <- readRDS("Last_Data_Update_Date.RDS")