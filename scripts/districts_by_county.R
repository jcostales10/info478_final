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

# Districts statistics (data frame and plots)
districts_data <- select(data, -School_District, -County) %>%
  aggregate(list(data$School_District), sum) %>%
  mutate(Immunization_Percentage = (Number_complete_for_all_immunizations/K_12_enrollment) * 100)
colnames(districts_data)[1] <- "School_District"
districts_data <- inner_join(districts_data, counties_districts, by = "School_District")
districts_in_counties <- split(districts_data, districts_data$County) 
 
districts_data <- rename(districts_data, subregion = County)


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
    geom_polygon(aes(x = long, y = lat, group = group, fill = bins)) +
  scale_fill_brewer(palette = "Blues") +
  coord_quickmap() +
  labs(title = " % Immunizations by County 2017", fill = "Immunization Percentage") +
  theme_void()




