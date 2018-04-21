shinyServer(function(input, output, session) {

  
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
  
  #Map tab
  Map_Vis_Func <- reactive({
    Map_Vis(selected_patent_years = input$map_select_patent_year)
  })
  
  output$map_vis_plot <- renderLeaflet({Map_Vis_Func()$vis})
  
  output$map_data <- renderDataTable({Map_Vis_Func()$data},options=list(pageLength=10, scrollX=TRUE))
  output$download_map_data <- downloadHandler(
    filename = function() { paste("IN_Map_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({Map_Vis_Func()$data}, file, row.names=FALSE)
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
      write.csv({Network_Vis_Func()$data}, file)
    }
  )
  
  #Treemap Chart
  Treemap_Func <- reactive({
    Treemap_Vis(year_ranges = input$patent_year_range)
  })
  
  output$tree_map <- renderPlot({
    Treemap_Func()$vis
  })
  
  output$treemap_data <- renderDataTable({Treemap_Func()$data},options=list(pageLength=10, scrollX=TRUE))
  
  output$download_treemap_data <- downloadHandler(
    filename = function() { paste("IN_Treemap_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({Treemap_Func()$data}, file)
    }
  )
  
  ##CPC Trends Tabs
  output$cpc_absolute_trends <- renderPlotly({
    CPC_Trend_Vis(type = 'absolute')$vis
  })
  
  output$cpc_trends1_data <- renderDataTable({CPC_Trend_Vis(type = 'absolute')$data},options=list(pageLength=10, scrollX=TRUE))
  
  output$download_cpc_trends1_data <- downloadHandler(
    filename = function() { paste("IN_CPC_Absolute_Trends_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({CPC_Trend_Vis(type = 'absolute')$data}, file)
    }
  )
  
  output$cpc_relative_trends <- renderPlotly({
    CPC_Trend_Vis(type = 'relative')$vis
  })
  
  output$cpc_trends2_data <- renderDataTable({CPC_Trend_Vis(type = 'relative')$data},options=list(pageLength=10, scrollX=TRUE))
  
  output$download_cpc_trends2_data <- downloadHandler(
    filename = function() { paste("IN_CPC_Relative_Trends_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({CPC_Trend_Vis(type = 'relative')$data}, file)
    }
  )

  #Circular Vis Tab
  Circular_Vis_Func <- reactive({
    Circular_Vis(select_year = input$patent_year, select_section = input$category)
  })

  output$polar_chart <- renderPlot({
    Circular_Vis_Func()$vis
  })
  
  output$circular_data <- renderDataTable({Circular_Vis_Func()$data},options=list(pageLength=10, scrollX=TRUE))
  output$download_circular_data <- downloadHandler(
    filename = function() { paste("IN_Circular_Data_", Sys.Date(), ".csv", sep="") },
    content = function(file) {
      write.csv({Circular_Vis_Func()$data}, file)
    }
  )

  output$inventor_text <- renderText({
    paste("Number of Inventors: ", Circular_Vis_Func()$data$inv_count)
  })

  output$assignee_text <- renderText({
    paste("Number of Assignees: ", Circular_Vis_Func()$data$assn_count)
  })

  
  #Pull data tab
  data_pull_msg <- eventReactive(input$pull_new_data, {
    Pull_Data()
  })
  
  output$upload_status <- renderText({data_pull_msg()})
  output$upload_date <- renderText({as.character(data_last_update)})
})
