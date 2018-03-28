shinyServer(function(input, output, session) {
  
  # Circular Vis Tab
  Circular_Vis_Func <- reactive({
    Circular_Vis(select_year = input$patent_year, select_section = input$category)
  })
  
  output$polar_chart <- renderPlot({
    Circular_Vis_Func()$vis
  })
  
  output$inventor_text <- renderText({
    paste("Number of Inventors: ", Circular_Vis_Func()$selected$inv_count)
  })
  
  output$assignee_text <- renderText({
    paste("Number of Assignees: ", Circular_Vis_Func()$selected$assn_count)
  })
  
  observe({
    updateSliderInput(session, "patent_year",
      min = min(Circular_Vis_Func()$data$year_granted), 
      max = max(Circular_Vis_Func()$data$year_granted))
  
    updateSelectInput(session, "category",
      choices = Circular_Vis_Func()$data$cpc_section_title)
  })
  
  #View all data tab
  View_All_Data_Func <- reactive({
    View_All_Data(fields = input$selected_field_list)
  })
 
  output$table_of_all_data <- DT::renderDataTable({View_All_Data_Func()},filter='top',rownames = FALSE,
                                                  options=list(pageLength=10, scrollX=TRUE))
  output$download_all_data <- downloadHandler(
    filename = function() { paste("IN_Patent_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({View_All_Data_Func()}, file)
    }
  )
  
  #Network Vis tab
  Network_Vis_Func <- reactive({
    Network_Vis(top_num = input$network_top_num, include = input$network_include)
  })
  
  output$network_vis_plot <- renderVisNetwork({Network_Vis_Func()$vis})
  
  output$network_data <- renderDataTable({Network_Vis_Func()$data},options=list(pageLength=10, scrollX=TRUE))
  output$download_network_data <- downloadHandler(
    filename = function() { paste("IN_Network_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({View_All_Data_Func()}, file)
    }
  )
  
  data_pull_msg <- eventReactive(input$pull_new_data, {
    Pull_Data()
  })
  
  output$upload_status <- renderText({data_pull_msg()})
  output$upload_date <- renderText({as.character(data_last_update)})
  
  
  #Treemap Chart
  # Circular Vis Tab
  Treemap_Func <- reactive({
    Treemap_Vis(year_ranges = input$patent_year_range)
  })
  
  output$tree_map <- renderPlot({
    Treemap_Func()$vis
  })
  
  
  # observe({
  #   updateSliderInput(session, "patent_year_range",
  #                     min = min(Treemap_Vis()$data$year_granted), 
  #                     max = max(Treemap_Vis()$data$year_granted))
  #   
  # })
  
  
})
