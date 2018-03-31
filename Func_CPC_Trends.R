CPC_Trend_Vis <- function(combined = IN_patent_data_combined, type){
  
  combined <- data.table(combined)[, 
                                   .(cpc_section_id, patent_year)]
  combined[cpc_section_id == "A", cpc_section_title := "Human Necessities"]
  combined[cpc_section_id == "B", cpc_section_title := "Operations and Transport"]
  combined[cpc_section_id == "C", cpc_section_title := "Chemistry and Metallurgy"]
  combined[cpc_section_id == "D", cpc_section_title := "Textiles"]
  combined[cpc_section_id == "E", cpc_section_title := "Fixed Constructions"]
  combined[cpc_section_id == "F", cpc_section_title := "Mechanical Engineering"]
  combined[cpc_section_id == "G", cpc_section_title := "Physics"]
  combined[cpc_section_id == "H", cpc_section_title := "Electricity"]

  
  combined_yr <- combined[!is.na(cpc_section_title), .(
    patents = .N
  ), by = .(cpc_section_title, patent_year)] %>%
    .[, pct_year := patents/sum(patents), by = patent_year]
  
  if(type == "absolute"){
    p <- plot_ly(combined_yr[, .(patent_year, patents, pct_year, cpc_section_title)],
                 x = ~patent_year,
                 y = ~patents,
                 name = ~cpc_section_title,
                 color = ~cpc_section_title,
                 type = 'scatter',
                 mode = 'lines',
                 hoverinfo = 'text',
                 #fill = 'tozeroy',
                 text = ~paste0(cpc_section_title, " (",patent_year,")\n",
                                "# of Patents: ", patents %>% comma, "\n",
                                "% of Year: ", pct_year %>% percent)
                ) %>%
                  layout(
                    title = "CPC Section Distribution Over Time",
                    xaxis = list(title = "Patent Grant Year", showgrid = FALSE),
                    yaxis = list(title = "Number of Patents Granted", showgrid = FALSE)
                  )
    
  }
  else if (type == 'relative'){
    p<- plot_ly(combined_yr,
            x = ~patent_year,
            y = ~pct_year*100,
            name = ~fct_rev(cpc_section_title),
            color = ~fct_rev(cpc_section_title),
            type = 'bar',
            hoverinfo = 'text',
            #fill = 'tozeroy',
            text = ~paste0(cpc_section_title, " (",patent_year,")\n",
                           "# of Patents: ", patents %>% comma, "\n",
                           "% of Year: ", pct_year %>% percent)
      ) %>%
        layout(
          barmode = 'stack',
          title = "CPC Section Distribution Over Time",
          xaxis = list(title = "Patent Grant Year", showgrid = FALSE),
          yaxis = list(title = "% Of Patent Grants in Year", showgrid = FALSE, ticksuffix = "%")
        )
      
  }
 
  output_list <- list(data = combined_yr, vis=p) 
  
  return(output_list)
}
  
