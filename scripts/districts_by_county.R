#install.packages("maps")
#install.packages("mapproj")
#install.packages("plotly")
#install.packages("rjson")

library(tidyr)
library(dplyr)
library(ggplot2)
library(plotly)
library("maps")
library("mapproj")

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

# County data frame
counties_data <- select(data, -School_District, -County) %>%
  aggregate(list(data$County), sum) %>%
  mutate(Immunization_Percentage = (Number_complete_for_all_immunizations/K_12_enrollment) * 100) %>%
  dplyr::arrange(-Immunization_Percentage)
colnames(counties_data)[1] <- "County"
#counties_plot <- counties_data %>%
#  plot_ly(x = ~Immunization_Percentage, y = ~County, name = "Immunization Rate in each County",
#          type = "bar", color = ~County, text = ~paste(County, ": ", Immunization_Percentage, "%", sep = ""),
#          hoverinfo = 'text') %>%
#  layout(
#    title = "Immunization Rate in each County",
#    xaxis = list(title = "Students with Complete Immunization (%)"),
#    showlegend = FALSE)
county_list <- counties_data$County

# WA Average
WA_average <- mean(counties_data$Immunization_Percentage)

# Top 10 Counties
#counties_top10 <- top_n(counties_data, 10, Immunization_Percentage)
#counties_top10_plot <- counties_top10 %>%
#  plot_ly(x = ~Immunization_Percentage, y = ~County, name = "Highest Immunization Rates by County",
#          type = "bar", color = ~County, text = ~paste(County, ": ", signif(Immunization_Percentage, 4), "%", sep = ""),
#          hoverinfo = 'text') %>%
#  layout(
#    title = "Highest Immunization Rates by County",
#    xaxis = list(title = "Students with Complete Immunization (%)"),
#    showlegend = FALSE)

# Districts data frame
districts_data <- dplyr::select(data, -School_District, -County) %>%
  aggregate(list(data$School_District), sum) %>%
  mutate(Immunization_Percentage = (Number_complete_for_all_immunizations/K_12_enrollment) * 100) %>%
  dplyr::arrange(-Immunization_Percentage)
colnames(districts_data)[1] <- "School_District"
districts_data <- inner_join(districts_data, counties_districts, by = "School_District")
districts_data <- districts_data %>%
  dplyr::select(School_District, K_12_enrollment, Number_complete_for_all_immunizations,
                Immunization_Percentage, County)
districts_in_counties <- split(districts_data, districts_data$County) 

for(i in 1:length(districts_in_counties)){
  assign(paste(names(districts_in_counties[i])), as.data.frame(districts_in_counties[[i]]))
}

dis_plot_func <- function(county_input, county){
   district_plot <- county_input %>%
    plot_ly(x = ~Immunization_Percentage, y = ~School_District, name = "Immunization Rate in each District",
            type = "bar", color = ~School_District, text = ~paste(School_District, ": ", signif(Immunization_Percentage, 4), "%", sep = ""),
            hoverinfo = 'text') %>%
    layout(
      title = paste("Immunization Rate in ", county, " County", sep = ""),
      xaxis = list(title = "Students with Complete Immunization (%)"),
      yaxis = list(title = "School District"),
      showlegend = FALSE)
  return(district_plot)
}

# Top 10 Districts
districts_top10 <- top_n(districts_data, 10, Immunization_Percentage)
districts_top10_plot <- districts_top10 %>%
  plot_ly(x = ~Immunization_Percentage, y = ~School_District, name = "Highest Immunization Rates by School District",
          type = "bar", color = ~School_District, text = ~paste(School_District, " in ", County, " County: ", signif(Immunization_Percentage, 4), "%", sep = ""),
          hoverinfo = 'text') %>%
  layout(
    title = "Highest Immunization Rates by School District",
    xaxis = list(title = "Students with Complete Immunization (%)"),
    yaxis = list(title = "School District"),
    showlegend = FALSE)

#---------------------------------------------------------------------------------------------

districts_data <- rename(districts_data, subregion = County)

# -------------- map of counties --------------
map_df <- map_data("county") %>%
  filter(region == "washington") %>%
  mutate(subregion = toupper(subregion))

subregion_data <- districts_data %>% 
  group_by(subregion) %>%
  summarize(Immunization_Percentage =
              sum(as.integer(Number_complete_for_all_immunizations))/sum(as.integer(K_12_enrollment))*100,
            K_12_enrollment = sum(as.integer(K_12_enrollment)),
            )

county_maps <- left_join(map_df, subregion_data, by = "subregion") 

county_maps$bins <- cut(
  county_maps$Immunization_Percentage,
  breaks =c(
    0, 50, 80, 85, 90, 93, 95, 100
  ),
  labels=c(
    "0-50% ",
    "50-80% ",
    "80-85%",
    "85-90%",
    "90-93%",
    "93-95%",
    "95-100"
   
  )
)
  
county_plot <- ggplot(county_maps) + 
    geom_polygon(aes(x = long, y = lat, group = group, fill = bins), colour = "black") +
  scale_fill_brewer(palette = "Blues") +
  coord_quickmap() +
  labs(title = " % Immunizations by County 2017", fill = "Immunization Percentage") +
  theme_void()
