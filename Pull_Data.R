library(patentsview)
library(dplyr)
library(purrr)

dt <- search_pv(
  query = qry_funs$eq(assignee_state     = "IN"),
  fields = c("patent_id",
             "patent_title",
             "patent_abstract",
             "patent_date",
             "patent_number",
             "patent_num_cited_by_us_patents", 
             "patent_year",
             "inventor_id",
             "inventor_first_name",
             "inventor_last_name",
             "inventor_total_num_patents",
             "assignee_id",
             "assignee_state",
             "assignee_city",
             "assignee_latitude",
             "assignee_longitude",
             "assignee_organization",
             "assignee_first_name",
             "assignee_last_name",
             "assignee_total_num_patents",
             "cpc_section_id",
             "cpc_subsection_title",
             "cpc_group_title",
             "app_number",
             "app_date",
             "nber_subcategory_title",
             "uspc_mainclass_title"
  ),
  sort = c("patent_number" = "asc"),
  all_pages = TRUE
)

#Cast Data Set to be correct
dt1 <- cast_pv_data(dt$data)

#Split Patent Data and inventor data
dt2 <- unnest_pv_data(dt1)

keep_first <- function(dataset){
  dt2[[dataset]] %>%
    group_by(patent_id) %>%
    filter(row_number() == 1)
}

#Keep First Row for Each Patent in Nested Sets
inventors <- keep_first("inventors")
assignees <- keep_first("assignees")
applications <- keep_first("applications")
uspsc <- keep_first("uspcs")
cpcs <- keep_first("cpcs")
nbers <- keep_first("nbers")

#Recombining the data set
combined <- reduce(list(
  dt2$patents,
  inventors,
  assignees,
  nbers,
  applications,
  uspsc,
  cpcs
  ),
  merge,
  by = "patent_id"
)

saveRDS(dt2, "IN_patent_data_unnested.RDS")
saveRDS(combined, "IN_patent_data_combined.RDS")
