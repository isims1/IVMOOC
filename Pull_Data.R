library(patentsview)
library(dplyr)

dt <- search_pv(
  query = qry_funs$eq(assignee_state     = "IN"),
  fields = c("patent_id",
             "patent_title",
             #"patent_abstract",
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
             "app_number",
             "appcit_date",
             "ipc_action_date",
             "nber_subcategory_title",
             "uspc_mainclass_title"
             
  ),
  sort = c("patent_number" = "asc"),
  all_pages = TRUE
  #per_page = 100
)

#Cast Data Set to be correct
dt1 <- cast_pv_data(dt$data)

#Split Patent Data and inventor data
dt2 <- unnest_pv_data(dt1)

#Keep Only First Inventor
inventors <-dt2$inventors %>%
  group_by(patent_id) %>%
  filter(row_number() == 1)

#Keep Only First Assignee
assignees <- dt2$assignees %>%
  group_by(patent_id) %>%
  filter(row_number() == 1)

#Recombining the data set
combined <- reduce(list(
  dt2$patents,
  inventors,
  assignees),
  merge,
  by = "patent_id"
)

saveRDS(dt2, "IN_patent_data_unnested.RDS")
saveRDS(combined, "IN_patent_data_combined.RDS")
