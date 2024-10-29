# Titanic Data

library(tidyverse)
library(tidyxl)
library(unpivotr)

View(readxl::read_xlsx("Data/titanic.xlsx")) 
# Titanic data is oddly shaped for R to deal with - missing values, headings are unusual

titanic <- xlsx_cells("Data/titanic.xlsx")

View(titanic) # reads in a table describing individual cells

behead(titanic, "up-left", "heading1") %>% # make first row of headings a heading
  behead("up", "heading2") %>%  # make second row of headings a heading
  behead("up", "heading3") %>% # make third row of headings a heading
  # combine all headings into a single header
  unite("heading", starts_with("heading"), na.rm = TRUE) %>% 
  # We have to fill in some blanks in the class column - arrange by column
  arrange(col) %>%
  fill(character, .direction = "down") %>% 
  mutate(data_type = case_when(col == 1 & is_blank ~ "character", .default = data_type)) %>% # need to update data type so that it pulls through in spatter
  select(row, heading, data_type, character, numeric, logical, date) %>% 
  spatter(key = heading) %>% 
  View
