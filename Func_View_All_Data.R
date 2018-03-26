View_All_Data <- function(data = IN_patent_data_combined, fields) {
  filtered_data <- data[,fields]
  return(filtered_data)
}