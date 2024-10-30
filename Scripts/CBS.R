# Community Blood Service
library(tidyverse)
library(tidyxl)
library(unpivotr)

cells <- xlsx_cells("Data/CBS.xlsx")

min_row <- cells %>%
  filter(character == "By Order Status within Consultant Specialty") %>% 
  select(row) %>% 
  unlist()

# Cell manipulation
cells1 <- cells %>%
  
  # Filter for correct table
  filter(row >= min_row,
         !is_blank) %>%
  
  # Select cells to be columns
  behead("up", "year") %>%
  behead("up", "month") %>%
  behead("left-up", "specialty") %>% #left # specialty or location # assign
  behead("left", "status") %>%  #left
  
  # Clean miscellaneous cells
  filter(status != "Total:",
         !str_detect(month, "Sum"),
         !str_detect(year, "Sum")) %>% 
  #fill(specialty) %>% #direction "down"
  
  # Converting to dates
  mutate(date = my(paste(month, year))) %>%
  select(specialty, status, date, n = numeric) #%>%
