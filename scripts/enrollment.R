library(tidyverse)
library(plotly)

vac_2017 <- read.csv("../data/immunization_2017.csv", stringsAsFactors = F)

# filter out all the schools not reported
reported_only <- vac_2017 %>%
  filter(Reported == "Y") %>%
  select(School_Name, K_12_enrollment, Percent_complete_for_all_immunizations)

# mean school enrollment size in the whole state
mean_enrollment <- reported_only %>%
  select(K_12_enrollment) %>%
  summarise(mean = mean(K_12_enrollment)) %>%
  pull(mean)

# mean percentage complete for all vaccinations in the whole state
mean_perc_vacinated <- reported_only %>%
  select(Percent_complete_for_all_immunizations) %>%
  summarise(mean = mean(Percent_complete_for_all_immunizations)) %>%
  pull(mean)

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
    title = "WA K - 12 Enrollment Sizes and Percent Vaccinated with All Vaccines by County",
    x = "Mean School Enrollment Size",
    y = "Mean Percent Complete of All Vacinations"
  )


# axis labels 
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

# plotly graph
fit <- lm(mean_perc_complete_all_vacinations ~ mean_enrollment, data = county_summary_stats)


enrollment_perc_complete_plotly <- county_summary_stats %>% 
  plot_ly(x = ~mean_enrollment, text = ~paste("County: ", County)) %>% 
  add_markers(y = ~mean_perc_complete_all_vacinations) %>% 
  add_lines(x = ~mean_enrollment, y = fitted(fit)) %>%
  layout(
    title = "WA K - 12 Enrollment Sizes and % Vaccinated with All Vaccines by County",
    xaxis = x, 
    yaxis = y,
    showlegend = FALSE)

# --------- added things for final deliverable 

attach(vac_2017)
county_counts <- vac_2017 %>%
  select(County) %>% 
  aggregate(by = list(County), FUN= length) %>%
  rename(count = County) %>%
  rename(County = Group.1)

top_three_enrollment <- vac_2017 %>%
  filter(Reported == "Y") %>% 
  group_by(County) %>%
  summarise(
    total = sum(K_12_enrollment)
  ) %>%
  arrange(-total) %>%
  top_n(3) %>%
  pull(County)

top_three_enrollment_values <- vac_2017 %>%
  filter(Reported == "Y") %>% 
  group_by(County) %>%
  summarise(
    total = sum(K_12_enrollment)
  ) %>%
  arrange(-total) %>%
  top_n(3) %>%
  pull(total)

bottom_three_enrollment <- vac_2017 %>%
  filter(Reported == "Y") %>% 
  group_by(County) %>%
  summarise(
    total = sum(K_12_enrollment)
  ) %>%
  arrange(-total) %>%
  top_n(-3) %>%
  pull(County)

bottom_three_enrollment_values <- vac_2017 %>%
  filter(Reported == "Y") %>% 
  group_by(County) %>%
  summarise(
    total = sum(K_12_enrollment)
  ) %>%
  arrange(-total) %>%
  top_n(-3) %>%
  pull(total)


# bottom three vac percent 
bottom_three_vac_perc <- vac_2017 %>%
  filter(Reported == "Y") %>% 
  group_by(County) %>%
  summarise(
    total = mean(Percent_complete_for_all_immunizations)
  ) %>%
  arrange(-total) %>%
  top_n(-3) %>%
  pull(County)

bottom_three_vac_perc_values <- vac_2017 %>%
  filter(Reported == "Y") %>% 
  group_by(County) %>%
  summarise(
    total = mean(Percent_complete_for_all_immunizations)
  ) %>%
  arrange(-total) %>%
  top_n(-3) %>%
  pull(total)
