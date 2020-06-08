library(tidyverse)
library(plotly)
library(shiny)

vac_2017 <- read.csv("data/immunization_2017.csv", stringsAsFactors = F)

# Count total of all exemptions

# filter out all the schools not reported and keep necessary columns
reported_only <- vac_2017 %>%
  filter(Reported == "Y") %>%
  select(School_Name, Number_with_medical_exemption,
         Number_with_personal_exemption, Number_with_religious_exemption,
         Number_with_religious_membership_exemption)


# calculate sum of exemptions and rename columns
exemption_sums <- reported_only %>%
  summarize(
    count_medical_exemption = sum(Number_with_medical_exemption),
    count_personal_exemption = sum(Number_with_personal_exemption),
    count_religious_exemption = sum(Number_with_religious_exemption),
    count_religious_membership_exemption = sum(Number_with_religious_membership_exemption)
  ) %>%
  rename("Personal exemption" = count_personal_exemption) %>%
  rename("Medical exemption" = count_medical_exemption) %>%
  rename("Religious exemption" = count_religious_exemption) %>%
  rename("Religious membership exemption" = count_religious_membership_exemption)
  
# organized exemption_sums to make it easy to work with
exemption_summary <- exemption_sums %>%
  gather(key = "reasons", value = "count",
         "Personal exemption", "Medical exemption",
         "Religious exemption", "Religious membership exemption") %>%
  arrange(-count)

# plotly piechart to display counts and percentages
exemption_vis <- plot_ly(data = exemption_summary, labels = ~reasons,
                         values = ~count, type = 'pie')

exemption_vis <- exemption_vis %>%
  layout(title = 'Exemption Count and Percentages',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

ggplot(exemption_summary, aes(x = "", y = count, fill = reasons)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar("y", start = 0) +
  theme_void() 
