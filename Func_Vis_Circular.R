Circular_Vis <- function(combined = IN_patent_data_combined, select_year, select_section){

  patents.data <- data.table(combined)
  
  patents.data[cpc_section_id == "A", cpc_section_title := "Human Necessities"]
  patents.data[cpc_section_id == "B", cpc_section_title := "Operations and Transport"]
  patents.data[cpc_section_id == "C", cpc_section_title := "Chemistry and Metallurgy"]
  patents.data[cpc_section_id == "D", cpc_section_title := "Textiles"]
  patents.data[cpc_section_id == "E", cpc_section_title := "Fixed Constructions"]
  patents.data[cpc_section_id == "F", cpc_section_title := "Mechanical Engineering"]
  patents.data[cpc_section_id == "G", cpc_section_title := "Physics"]
  patents.data[cpc_section_id == "H", cpc_section_title := "Electricity"]
  patents.data[is.na(cpc_section_id) == TRUE, cpc_section_title := "Other"]  
  
  grouped <- patents.data %>%
    mutate(year_granted = as.integer(patent_year)) %>%
    select(assignee_id, inventor_id, year_granted, cpc_section_title) %>%
    group_by(year_granted, cpc_section_title) %>%
    summarise(inv_count = n_distinct(inventor_id),
              assn_count = n_distinct(assignee_id))

  selected <- grouped %>%
    filter(year_granted == select_year, cpc_section_title == select_section)

  inv = ifelse(dim(selected[1] == 0), 0, selected$inv_count)
  assn = ifelse(dim(selected[1] == 0), 0, selected$assn_count)
  
  plot.dt <- data.table(x = c(1, 2),
    category = c("Inventors", "Assignees"),
    count = c(inv, assn))
  
  y_limit = max(c(grouped$inv_count, grouped$assn_count))
  
  circle.plot <- ggplot(plot.dt, aes(x = x, y = sqrt(count), fill = category)) + 
    geom_col(width = 1) +
    scale_y_continuous(limits = c(0, sqrt(y_limit))) +
    # scale_x_discrete(expand = c(0,0), limits = c(0.5, 5)) +
    coord_polar(theta = "x", direction = -1) +
    theme_void() +
    labs(fill = 'CPC Category', y = 'Number')

  output_list <- list(data = grouped, vis=circle.plot, selected = selected) 

  return(output_list)
  
}
