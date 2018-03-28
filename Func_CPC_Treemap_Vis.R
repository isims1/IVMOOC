Treemap_Vis <- function(combined = IN_patent_data_combined, year_ranges){
  
  combined <- data.table(combined)[between(patent_year, year_ranges[1], year_ranges[2]), 
                                   .(cpc_section_id, cpc_subsection_title, cpc_group_title)]
  combined[cpc_section_id == "A", cpc_section_title := "Human Necessities"]
  combined[cpc_section_id == "B", cpc_section_title := "Operations and Transport"]
  combined[cpc_section_id == "C", cpc_section_title := "Chemistry and Metallurgy"]
  combined[cpc_section_id == "D", cpc_section_title := "Textiles"]
  combined[cpc_section_id == "E", cpc_section_title := "Fixed Constructions"]
  combined[cpc_section_id == "F", cpc_section_title := "Mechanical Engineering"]
  combined[cpc_section_id == "G", cpc_section_title := "Physics"]
  combined[cpc_section_id == "H", cpc_section_title := "Electricity"]
  
  tmap <- combined[!is.na(cpc_section_title), .(value = .N) , by = .(cpc_section_title,
                                                                     cpc_subsection_title,
                                                                     cpc_group_title
  )]
  
  tmap[, section_sum := sum(value), by = cpc_section_title]
  tmap[, subsection_sum := sum(value), by = .(cpc_section_title, 
                                              cpc_subsection_title)]
  tmap[, group_sum := sum(value), by = .(cpc_section_title, 
                                         cpc_subsection_title, 
                                         cpc_group_title)]
  

  tmap[, section := str_wrap(paste(cpc_section_title, section_sum %>% comma), 100)]
  tmap[, subsection := str_wrap(paste(cpc_subsection_title, subsection_sum %>% comma), 100)]
  tmap[, group := str_wrap(paste(cpc_group_title, group_sum %>% comma), 100)]
  
  
  tm <- treemap(
    tmap,
    index = c("section",
              "subsection",
              "group"
    ),  
    vSize = 'value',
    draw=TRUE,
    title="COOPERATIVE PATENT CLASSIFICATION"
  )
  
  #pdf(NULL)
  #viz <- d3tree3( tm , rootname = "COOPERATIVE PATENT CLASSIFICATION" )
  
  output_list <- list(data = tmap, vis=tm) 
  
  return(output_list)
}
  
