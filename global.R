library(shiny)
library(dplyr)
library(patentsview)
library(purrr)
library(visNetwork)
library(shinydashboard)

#source functions
source("Func_View_All_Data.R")
source("Func_Network_Vis.R")

#load data
IN_patent_data_combined <- readRDS("IN_patent_data_combined.RDS")
IN_patent_data_unnested <- readRDS("IN_patent_data_unnested.RDS")