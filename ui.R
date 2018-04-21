shinyUI(
  dashboardPage(skin = "blue",
    dashboardHeader(title = "IN Patent Dashboard"
    ),
    dashboardSidebar(
      sidebarMenu(id="tabs",
        menuItem("Table View", tabName = "table_view", icon = icon("table")),
        menuItem("Map Vis", tabName = "map_vis", icon = icon("map")),
        menuItem("Network Vis", tabName = "network_vis", icon = icon("sitemap")),
        menuItem("CPC Industry Breakdown", tabName = "cpc_treemap", icon = icon("angle-double-down")),
        menuItem("CPC Industry Trends", tabName = "cpc_trends", icon = icon("line-chart")),
        menuItem("Investors/Assignees", tabName="inv_assn", icon = icon("adjust")),
        menuItem("Pull New Data", tabName = "pull_data", icon = icon("database"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "table_view",
          fluidRow(
            column(12,
              selectInput("selected_field_list", label = "Select From Available Fields:",
                choices = colnames(IN_patent_data_combined),
                multiple = TRUE,
                selected = c("patent_id","patent_title","patent_date","inventor_first_name", "inventor_last_name","assignee_organization"),
                width = "100%"
              )
            )
          ),
          dataTableOutput("table_of_all_data") %>% withSpinner(),
          br(),
          div(style="float:right", downloadButton("download_all_data", "Download Data")),
          br()
        ),
        tabItem(tabName = "map_vis",
          fluidRow(
            column(1
            ),
            column(9,
               selectInput("map_select_patent_year", label = "Select Patent Year(s):",
                           choices = sort(unique(IN_patent_data_combined$patent_year),decreasing = TRUE),
                           multiple = TRUE,
                           selected = c(max(IN_patent_data_combined$patent_year),max(IN_patent_data_combined$patent_year)-1),
                           width = "100%"
               )
            ),
            column(2,
               radioButtons("map_plot_or_data", "Plot or Data",
                            c("Plot" = "map_pickedPlot", "Data" = "map_pickedData" ),
                            selected = "map_pickedPlot",
                            inline = T
               )
            )
          ),
          br(),
          conditionalPanel(
            condition = "input.map_plot_or_data=='map_pickedPlot'",
            leafletOutput("map_vis_plot", width = "100%", height = "700px") %>% withSpinner()
          ),
          conditionalPanel(
            condition = "input.map_plot_or_data=='map_pickedData'",
            dataTableOutput("map_data") %>% withSpinner(),
            br(),
            div(style="float:right", downloadButton("download_map_data", "Download Data")),
            br()
          )
        ),
        tabItem(tabName = "network_vis",
          fluidRow(
            column(3,
              selectInput("network_top_num", label = "Top ? Cited Patents",
                choices = c(10,25,50,100),
                multiple = FALSE,
                selected = c(10),
                width = "100%"
              )
            ),
            column(3,
              selectInput("network_include", label = "Include",
                choices = c("Assignees","Inventors", "Assignees and Inventors"),
                multiple = FALSE,
                selected = c("Assignees and Inventors"),
                width = "100%"
              )
            ),
            column(3,
              radioButtons("network_plot_or_data", "Plot or Data",
                c("Plot" = "network_pickedPlot", "Data" = "network_pickedData" ),
                selected = "network_pickedPlot",
                inline = T
              )
            )
          ),
          br(),
          conditionalPanel(
            condition = "input.network_plot_or_data=='network_pickedPlot'",
            visNetworkOutput("network_vis_plot", width = "100%", height = "700px") %>% withSpinner()
          ),
          conditionalPanel(
            condition = "input.network_plot_or_data=='network_pickedData'",
            dataTableOutput("network_data") %>% withSpinner(),
            br(),
            div(style="float:right", downloadButton("download_network_data", "Download Data")),
            br()
          )
        ),
        tabItem(tabName ="cpc_treemap",
          fluidRow(
            column(6,
                   sliderInput("patent_year_range", 
                               label = h3("Patent Year Range"), 
                               min = min(IN_patent_data_combined$patent_year), 
                               max = max(IN_patent_data_combined$patent_year), 
                               value = c(min(IN_patent_data_combined$patent_year), max(IN_patent_data_combined$patent_year)), step = 1, sep = "")
            ),
            column(3,
                   radioButtons("treemap_plot_or_data", "Plot or Data",
                                c("Plot" = "treemap_pickedPlot", "Data" = "treemap_pickedData" ),
                                selected = "treemap_pickedPlot",
                                inline = T
                   )
            )
          ),
          br(),
          conditionalPanel(
            condition = "input.treemap_plot_or_data=='treemap_pickedPlot'",
            plotOutput("tree_map", height = "700px") %>% withSpinner()
          ),
          conditionalPanel(
            condition = "input.treemap_plot_or_data=='treemap_pickedData'",
            dataTableOutput("treemap_data") %>% withSpinner(),
            br(),
            div(style="float:right", downloadButton("download_treemap_data", "Download Data")),
            br()
          )
        ),
        tabItem(tabName ="cpc_trends",
                tabsetPanel(
                  type='tabs',
                  tabPanel("CPC Trends (Absolute)", 
                             br(),
                             fluidRow(
                               column(3,
                                      radioButtons("cpc_trends1_plot_or_data", "Plot or Data",
                                                   c("Plot" = "cpc_trends1_pickedPlot", "Data" = "cpc_trends1_pickedData" ),
                                                   selected = "cpc_trends1_pickedPlot",
                                                   inline = T
                                      )
                               )
                             ),
                             br(),
                             conditionalPanel(
                               condition = "input.cpc_trends1_plot_or_data=='cpc_trends1_pickedPlot'",
                               plotlyOutput("cpc_absolute_trends", height = "700px") %>% withSpinner()
                             ),
                             conditionalPanel(
                               condition = "input.cpc_trends1_plot_or_data=='cpc_trends1_pickedData'",
                               dataTableOutput("cpc_trends1_data") %>% withSpinner(),
                               br(),
                               div(style="float:right", downloadButton("download_cpc_trends1_data", "Download Data")),
                               br()
                             )
                  ),
                  tabPanel("CPC Trends (Relative)", 
                           br(),
                           fluidRow(
                             column(3,
                                    radioButtons("cpc_trends2_plot_or_data", "Plot or Data",
                                                 c("Plot" = "cpc_trends2_pickedPlot", "Data" = "cpc_trends2_pickedData" ),
                                                 selected = "cpc_trends2_pickedPlot",
                                                 inline = T
                                    )
                             )
                           ),
                           br(),
                           conditionalPanel(
                             condition = "input.cpc_trends2_plot_or_data=='cpc_trends2_pickedPlot'",
                             plotlyOutput("cpc_relative_trends", height = "700px") %>% withSpinner()
                           ),
                           conditionalPanel(
                             condition = "input.cpc_trends2_plot_or_data=='cpc_trends2_pickedData'",
                             dataTableOutput("cpc_trends2_data") %>% withSpinner(),
                             br(),
                             div(style="float:right", downloadButton("download_cpc_trends2_data", "Download Data")),
                             br()
                           )
                  )
                )
        ),
        tabItem(tabName ="inv_assn",
                fluidRow(
                  column(3,
                         sliderInput("patent_year", "Year", min = min(IN_circular_vis_data$year_granted),
                                     max = max(IN_circular_vis_data$year_granted), value = max(IN_circular_vis_data$year_granted), sep = "", step = 1)
                  ),
                  column(3,
                         selectInput("category", "Patent Category",
                                     choices = unique(IN_circular_vis_data$cpc_section_title), 
                                     selected=unique(IN_circular_vis_data$cpc_section_title)[1])
                  ),
                  column(3,
                         span(textOutput("inventor_text"), style="size:14"),
                         span(textOutput("assignee_text"), style="size:14")
                  ),
                  column(3,
                         radioButtons("circular_plot_or_data", "Plot or Data",
                                      c("Plot" = "circular_pickedPlot", "Data" = "circular_pickedData" ),
                                      selected = "circular_pickedPlot",
                                      inline = T
                         )
                  )
                ),
                br(),
                conditionalPanel(
                  condition = "input.circular_plot_or_data=='circular_pickedPlot'",
                  plotOutput("polar_chart") %>% withSpinner()
                ),
                conditionalPanel(
                  condition = "input.circular_plot_or_data=='circular_pickedData'",
                  dataTableOutput("circular_data") %>% withSpinner(),
                  br(),
                  div(style="float:right", downloadButton("download_circular_data", "Download Data")),
                  br()
                )
                # fluidRow(
                #   column(12,
                #          sliderInput("patent_year", "Year", min = 1976,
                #                      max = 2017, value = 2017, sep = "", step = 1),
                #          selectInput("category", "Patent Category",
                #                      choices = c("Other"), selected="Other"),
                #          plotOutput("polar_chart"),
                #          span(textOutput("inventor_text"), style="size:14"),
                #          span(textOutput("assignee_text"), style="size:14")
                #   )
                # )
        ),
        tabItem(tabName = "pull_data",
          fluidRow(
            column(12,
               helpText("Click below to pull new data (this can take a while). A notification will display when it is done."),
               actionButton("pull_new_data", "Update Data"),
               br(),
               br(),
               textOutput("upload_status") %>% withSpinner(),
               br(),
               helpText("Last time data was updated:"),
               textOutput("upload_date"),
               br(),
               br(),
               br()
            )
          )
        )
      )
    )
  )
)
