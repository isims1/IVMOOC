Network_Vis <- function(combined = IN_patent_data_combined, unnested = IN_patent_data_unnested, top_num, included) {
  
  #Function to delist by patent_id
  delist <- function(dataset){
    unnested[[dataset]] %>%
      group_by(patent_id)
  }
  
  #get full inventor list into data frame
  all_inventor <- delist("inventors")
  all_inventor$inventor_full_name <- paste(all_inventor$inventor_first_name, all_inventor$inventor_last_name)
  
  top_cited <- head(arrange(combined,desc(patent_num_cited_by_us_patents)), n = top_num)
  
  #pull patent and assignee seperately
  patent <- top_cited[,c("patent_id","patent_title","patent_num_cited_by_us_patents")]
  assignee <- top_cited[,c("assignee_id", "assignee_organization","assignee_total_num_patents")]
  
  #remove duplicate assignees
  distinct_assignee <- unique(assignee)
  
  #get narrowed list of inventors for given top patents
  inventor <- all_inventor[all_inventor$patent_id %in% patent$patent_id,]
  
  inventor_out <- inventor[,c("patent_id","inventor_id","inventor_first_name","inventor_last_name","inventor_total_num_patents")]
  
  #need to create distinct key for inventors by patent since they can be on multiple patents
  inventor$inventor_node_id <- paste0(inventor$inventor_id,"_",inventor$patent_id)
  
  #get range for assignee icon sizes
  min_patent <- min(distinct_assignee$assignee_total_num_patents)
  max_patent <- max(distinct_assignee$assignee_total_num_patents)
  rng_patent <- max_patent - min_patent
  
  #get range for patent icon sizes
  min_citation <- min(patent$patent_num_cited_by_us_patents)
  max_citation <- max(patent$patent_num_cited_by_us_patents)
  rng_citation <- max_citation - min_citation
  
  #get range for inventor icon sizes
  min_inv_patent <- min(inventor$inventor_total_num_patents)
  max_inv_patent <- max(inventor$inventor_total_num_patents)
  rng_inv_patent <- max_inv_patent - min_inv_patent
  
  #set up node data
  assignee_nodes <- data.frame("id"=distinct_assignee$assignee_id, 
                               "label"="" , 
                               "group"="assignee", 
                               "title"=paste0(distinct_assignee$assignee_organization," (",distinct_assignee$assignee_total_num_patents," patents)"), 
                               "shadow"="TRUE", 
                               "shape"="icon", 
                               "icon.face"="FontAwesome", 
                               "icon.code"="f19c", 
                               "icon.size"=((((distinct_assignee$assignee_total_num_patents-min_patent)*125)/rng_patent) + 25), 
                               "icon.color"="black")
  patent_nodes <- data.frame("id"=patent$patent_id, 
                             "label"="" , 
                             "group"="patent", 
                             "title"=paste0(patent$patent_title," (",patent$patent_num_cited_by_us_patents," U.S. citations)"), 
                             "shadow"="TRUE", 
                             "shape"="icon", 
                             "icon.face"="FontAwesome", 
                             "icon.code"="f15b", 
                             "icon.size"=(((patent$patent_num_cited_by_us_patents-min_citation)*90)/rng_citation) + 10, 
                             "icon.color"="green")
  inventor_nodes <- data.frame("id"=inventor$inventor_node_id, 
                               "label"="" , 
                               "group"="patent", 
                               "title"=paste0(inventor$inventor_full_name," (",inventor$inventor_total_num_patents," patents)"), 
                               "shadow"="TRUE", 
                               "shape"="icon", 
                               "icon.face"="FontAwesome", 
                               "icon.code"="f007", 
                               "icon.size"=(((inventor$inventor_total_num_patents-min_inv_patent)*90)/rng_inv_patent) + 10, 
                               "icon.color"="blue")
  
  assignee_edges <- data.frame("from"=top_cited$assignee_id, "to"=top_cited$patent_id, "label"="", "length"=200, "title"="", "smooth"="TRUE", "shadow"="TRUE")
  inventor_edges <- data.frame("from"=inventor$patent_id, "to"=inventor$inventor_node_id, "label"="", "length"=100, "title"="", "smooth"="TRUE", "shadow"="TRUE")
  
  patent_assignee_out <- cbind(assignee, patent)
    
  #combine node and edge data
  if(included == "Assignees and Inventors"){
    nodes <- rbind(patent_nodes, assignee_nodes, inventor_nodes)
    edges <- rbind(assignee_edges, inventor_edges)
    outdata <- merge(patent_assignee_out, inventor_out, by="patent_id")
    legend <- list(
      list(label = "Assignees (sized by # patents)", shape = "icon", 
           icon = list(code = "f19c", size = 50, color = "black")),
      list(label = "Patents (sized by # citations)", shape = "icon", 
           icon = list(code = "f15b", size = 50, color = "green")), 
      list(label = "Inventors (sized by # patents)", shape = "icon", 
           icon = list(code = "f007", size = 50, color = "blue")))
  } else if(included == "Inventors"){
    nodes <- rbind(patent_nodes, inventor_nodes)
    edges <- inventor_edges
    outdata <- merge(patent, inventor_out, by="patent_id")
    legend <- list(
      list(label = "Patents (sized by # citations)", shape = "icon", 
           icon = list(code = "f15b", size = 50, color = "green")), 
      list(label = "Inventors (sized by # patents)", shape = "icon", 
           icon = list(code = "f007", size = 50, color = "blue")))
  } else {
    nodes <- rbind(patent_nodes, assignee_nodes)
    edges <- assignee_edges
    outdata <- patent_assignee_out
    legend <- list(
      list(label = "Assignees (sized by # patents)", shape = "icon", 
           icon = list(code = "f19c", size = 50, color = "black")),
      list(label = "Patents (sized by # citations)", shape = "icon", 
           icon = list(code = "f15b", size = 50, color = "green")))
  } 

  #produce visualization
  plot <- visNetwork(nodes, edges, main = paste0("Top ", top_num, " Most Cited Indiana Patents with ", included), width = "100%") %>%
            addFontAwesome() %>%
            visInteraction(navigationButtons = TRUE) %>%
            visLegend(addNodes = legend,
              useGroups = FALSE)
  
  output_list <- list(data=outdata, vis=plot)
  
  return(output_list)
  
}