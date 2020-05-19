library(tidyr)
library(dplyr)
library(plotly)

data <- read.csv(
  "../data/immunization_2017.csv",
  stringsAsFactors = FALSE
)

# Filter data to columns used 
data <- filter(data, Reported == "Y") %>%
  select(-Reported, -School_Name, -School_year, -ESD, -Grade_Levels,
         -Has_kindergarten, -Has_6thGrade, -Location.1, -contains("Percent"))

# County statistics (data frame and plot)
counties_data <- select(data, -School_District, -County) %>%
  aggregate(list(data$County), sum) %>%
  mutate(Immunization_Percentage = (Number_complete_for_all_immunizations/K_12_enrollment) * 100)
colnames(counties_data)[1] <- "County"
counties_plot <- counties_data %>%
  plot_ly(x = ~Immunization_Percentage, y = ~County, name = "Immunization Rate in each County",
          type = "bar", color = ~County, text = ~paste(County, ": ", signif(Immunization_Percentage, 4), "%", sep = ""),
          hoverinfo = 'text') %>%
  layout(
    title = "Immunization Rate in each County",
    xaxis = list(title = "Students with Complete Immunization (%)"),
    showlegend = FALSE)
counties_plot  

#  ggplot(counties_data) + 
#  geom_bar(mapping = aes(x = County, y = Immunization_Percentage, fill = County), stat = "identity",
#           show.legend = FALSE) + 
#  geom_text(mapping = aes(x = County, y = Immunization_Percentage,
#                          label = signif(Immunization_Percentage, digits = 4)), size = 2.5) +
#  labs(title = "Immunization Rate in each County", y = "Immunization Rate") +
#  coord_flip()
#counties_plot