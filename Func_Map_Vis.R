Map_Vis <- function(combined = IN_patent_data_combined, selected_patent_years) {
  
  combined <- combined[combined$patent_year %in% selected_patent_years,]
  combined$patentsview_link <- paste0('http://www.patentsview.org/web/#detail/patent/',combined$patent_number)
  combined$google_patents_link <- paste0('https://patents.google.com/patent/US',combined$patent_number)

  m <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    #addResetMapButton() %>%
    addMarkers( 
      lat = as.numeric(combined$assignee_latitude),
      lng = as.numeric(combined$assignee_longitude),
      clusterOptions = markerClusterOptions(),
      group = 'patents',
      popup = paste(
        "<b>Patent Number:</b>", combined$patent_number,"<br />",
        "<b>Patent Title:</b>", combined$patent_title,"<br />",
        "<b>Patent Year:</b>", combined$patent_year,"<br />",
        "<b>Application Date:</b>", combined$app_date, "<br />",
        "<b>Patent Grant Date:</b>", combined$patent_date, "<br />",
        "<b>Organization:</b>", combined$assignee_organization,"<br />",
        "<b>Category</b>", combined$nber_subcategory_title, "<br />",
        "<b>Inventor Name:</b>", paste(combined$inventor_first_name,
                                       combined$inventor_last_name),"<br />",
        "<b>Location:</b>", paste0(combined$assignee_city,", ",
                                   combined$assignee_state),"<br />",
        "<b>Abstract</b>", paste0(str_sub(combined$patent_abstract, 1, 100),"..."),"<br />",
        "<b>External Links:</b><br />",
        "&nbsp;&nbsp;&nbsp;&nbsp;",
        paste0("<a href='",file.path('http://www.patentsview.org/web/#detail/patent',combined$patent_number), "'> PatentView</a><br />"),
        "&nbsp;&nbsp;&nbsp;&nbsp;",
        paste0("<a href='https://patents.google.com/patent/US",combined$patent_number,"'> Google Patents</a><br />")
      ) 
    )
  
  outdata <- combined[, c("patent_number","patent_title","patent_year","app_date","patent_date","assignee_organization",
                          "nber_subcategory_title","inventor_first_name","inventor_last_name","assignee_city","assignee_state",
                          "patent_abstract","assignee_latitude","assignee_longitude","patentsview_link","google_patents_link")]
  
  output_list <- list(data=outdata, vis=m)
  
  return(output_list)
  
}


