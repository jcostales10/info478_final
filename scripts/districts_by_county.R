library(tidyr)
library(dplyr)
library(ggplot2)

data <- read.csv(
  "../data/immunization_2017.csv",
  stringsAsFactors = FALSE
)

# Filter data to columns used 
data <- filter(data, Reported == "Y") %>%
  select(-Reported, -School_Name, -School_year, -ESD, -Grade_Levels,
         -Has_kindergarten, -Has_6thGrade, -Location.1, -contains("Percent"))

# Data frame to keep track of which district is in which county
counties_districts <- select(data, School_District, County) %>%
  distinct(School_District, .keep_all = TRUE)

# Districts statistics (data frame and plots)
districts_data <- select(data, -School_District, -County) %>%
  aggregate(list(data$School_District), sum) %>%
  mutate(Immunization_Percentage = (Number_complete_for_all_immunizations/K_12_enrollment) * 100)
colnames(districts_data)[1] <- "School_District"
districts_data <- inner_join(districts_data, counties_districts, by = "School_District")
districts_in_counties <- split(districts_data, districts_data$County)
i <- 1
plot_list <- list()
while(i <= length(districts_in_counties)){
  df <- data.frame(districts_in_counties[[i]])
  plot_list[[i]] <- df
  i <- i + 1
}
districts_plot <- lapply(plot_list, function(x){
  ggplot(x) +
    geom_bar(mapping = aes(x = School_District, y = Immunization_Percentage, fill = School_District),
             stat = "identity", show.legend = FALSE) +
    geom_text(mapping = aes(x = School_District, y = Immunization_Percentage,
                            label = signif(Immunization_Percentage, digits = 4)), size = 3) +
    labs(x = "School District", y = "Immunization Rate") +
    coord_flip() + 
    facet_wrap(~County)
  }
)