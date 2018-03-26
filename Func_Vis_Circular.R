library(ggplot2)
library(data.table)
library(dplyr)
library(shiny)

patents.data <- data.table(readRDS("IN_patent_data_combined.RDS"))

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

# Define UI ----
ui <- fluidPage(
  sliderInput("patent_year", "Year", 
              min = min(grouped$year_granted), 
              max = max(grouped$year_granted),
              value = max(grouped$year_granted),
              sep = "",
              step = 1),
  selectInput("category", "Patent Category",
              choices = unique(grouped$cpc_section_title)),
  plotOutput("polar_chart"),
  span(textOutput("inventor_text"), style="size:14"),
  span(textOutput("assignee_text"), style="size:14")
)

# Define Server Logic
server <- function(input, output) {
  
  selected <- reactive({
    
    select_year = input$patent_year
    select_section = input$category
    
    grouped %>%
      filter(year_granted == select_year, cpc_section_title == select_section)
    
  })
  
  selected_df <- reactive({
    
    inv = ifelse(dim(selected())[1] == 0, 0, selected()$inv_count)
    assn = ifelse(dim(selected())[1] == 0, 0, selected()$assn_count)
    
    data.table(x = c(1, 2),
               category = c("Inventors", "Assignees"),
               count = c(inv, assn))
    
  })
  
  output$polar_chart <- renderPlot({
    
    y_limit = max(c(grouped$inv_count, grouped$assn_count))
    
    ggplot(selected_df(), aes(x = x, y = sqrt(count), fill = category)) + geom_col(width = 1) +
      scale_y_continuous(limits = c(0, sqrt(y_limit))) +
      # scale_x_discrete(expand = c(0,0), limits = c(0.5, 5)) +
      coord_polar(theta = "x", direction = -1) +
      theme_void() +
      labs(fill = 'CPC Category', y = 'Number')
    
  })
  
  output$inventor_text <- renderText({
    paste("Number of Inventors: ", selected()$inv_count)
  })
  
  output$assignee_text <- renderText({
    paste("Number of Assignees: ", selected()$assn_count)
  })
  
}

# Run the App
shinyApp(ui = ui, server = server)