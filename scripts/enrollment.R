library(tidyverse)
library(plotly)

vac_2017 <- read.csv("info478_final/data/immunization_2017.csv", stringsAsFactors = F)

# filter out all the schools not reported
reported_only <- vac_2017 %>%
  filter(Reported == "Y") %>%
  select(School_Name, K_12_enrollment, Percent_complete_for_all_immunizations)

# mean school enrollment size in the whole state
mean <- reported_only %>%
  select(K_12_enrollment) %>%
  summarise(mean = mean(K_12_enrollment))

# group by county
county_summary_stats <- vac_2017 %>%
  filter(Reported == "Y") %>%
  group_by(County) %>%
  summarise(
    mean_enrollment = mean(K_12_enrollment),
    mean_perc_complete_all_vacinations = mean(Percent_complete_for_all_immunizations),
    mean_perc_medical_excemption = mean(Percent_with_any_exemption),
    mean_perc_personal_excemption = mean(Percent_with_personal_exemption),
    mean_perc_religous_excemption = mean(Percent_with_religious_exemption),
    mean_perc_religous_mem_excemption = mean(Percent_with_religious_membership_exemption)
  )


enrollment_perc_complete <- county_summary_stats %>%
  ggplot + geom_point(mapping = aes(x =  mean_enrollment, y = mean_perc_complete_all_vacinations)) +
  geom_smooth(mapping = aes(x = mean_enrollment, y = mean_perc_complete_all_vacinations), method=lm) +
  labs(
    title = "Washington K - 12 Enrollment Sizes and Percent Vaccinated with All Vaccines by County",
    x = "Mean School Enrollment Size",
    y = "Mean Percent Complete of All Vacinations"
  )


f <- list(
  family = "Courier New, monospace",
  size = 18,
  color = "#7f7f7f"
)

x <- list(
  title = "Mean School Enrollment Size",
  titlefont = f
)
y <- list(
  title = "Mean Percent Complete of All Vacinations",
  titlefont = f
)



test1 <-  plot_ly(data = county_summary_stats, 
              x = ~mean_enrollment, 
              y = ~mean_perc_complete_all_vacinations,
              mode = "markers",
              text = ~paste("County: ", County)) %>%
  layout(
    title = "Washington K - 12 Enrollment Sizes and Percent Vaccinated with All Vaccines by County",
    xaxis = x, 
    yaxis = y)
  


test2 <- test %>%
  add_trace( x = mean_enrollment, y = mean_perc_complete_all_vacinations, mode = "lines")
