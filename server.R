shinyServer(function(input, output, session) {
  
  #View all data tab
  View_All_Data_Func <- reactive({
    View_All_Data(fields = input$selected_field_list)
  })
  
 
  output$table_of_all_data <- renderDataTable({View_All_Data_Func()},options=list(pageLength=10, scrollX=TRUE))
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
  
  
})