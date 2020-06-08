#UI 
library(shiny)
library(ggplot2)
library(plotly)

source("scripts/exemptions.R")


### Intro Page ###
intro_page <- tabPanel(
  "Introduction",
  mainPanel(
    h2("Insert Intro"),

  )
)


### Page 1 ###

# insert code for buttons/sliders here

w <- tabPanel(
  "Insert title",
  h1("Page 1 Title"),
  sidebarLayout(
    sidebarPanel(
      #insert button/slider variables here
    ),
    mainPanel(
      # insert plot here 
    )
  ),
  
  h2("Insert findings/research/etc"),
)



### Exemptions ###

# insert code for buttons/sliders here

x <- tabPanel(
  "Reasons for Exemption",
  h1("Reasons for Exemption"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        "exemptions",
        label = h3("Exemption Reasons"),
        choices = list(
          "Personal" = exemption_sums$`Personal exemption`,
          "Medical" = exemption_sums$`Medical exemption`,
          "Religious" = exemption_sums$`Religious exemption`,
          "Religious membership" = exemption_sums$`Religious membership exemption`
        ),
        selected = c(exemption_sums$`Personal exemption`, exemption_sums$`Medical exemption`,
                     exemption_sums$`Religious exemption`, exemption_sums$`Religious membership exemption`)
      )
      
    ),
    mainPanel(
      plotlyOutput(outputId = "exemption_vis")
    )
  ),
  
  h2("Findings and Future Implications"),
  p("We wanted to know more about the distribution of the reasons for not vaccinating. 
  We thought that if we knew the distribution, we would know where to best focus efforts 
  in addressing the lack of vaccination."),
  p("This pie chart displays the count and percentage of the different reasons for not 
    vaccinating. We can deduce that not vaccinating due to personal exemption makes up 
    71.6% (44,104 children) of the total number of children (61,598 children) who didn’t 
    get vaccinated. We see that we should be focusing our efforts in targeting children 
    who have personal exemptions."),
  p("Another cause of concern is the number of disease outbreaks attributed to religious
    groups. For example, since recorded in September 2018, there are 535 confirmed
    cases of measles among Orthodox Jewish communities in Brooklyn and Queens alone, a
    disease declared."),
  p("Recent trends have shown that in states where there is a ban on personal exemptions,
    there have been a rise in religious exemptions despite only a few religions that
    are against vaccinations. An example is the state of Vermont. The state banned religious
    exemptions and in the following years, there were 7x more religious exemptions than
    before the ban."),
  p("In May 2019, the Washington State Legislature passed a bill that removes the personal
    and philosophical option to exempt children from the MMR (measles, mumps, and rubella)
    vaccine required for school and child care entry. This law does not change religious and
    medical exemption laws. The data used to produce the charts is data from the 2017 school
    year, before the bill was passed. Although there will be a decline in the number of
    personal exemptions, there might be an increase in relgious exemptions."),
  p("Religious exemptions may be an increasingly problematic or outdated exemption category, 
    and researchers and policy makers must work together to determine how best to balance a 
    respect for religious liberty with the need to protect public health.")
)


### Page 3 ###

# insert code for buttons/sliders here

y <- tabPanel(
  "Insert title",
  h1("Page 3 Title"),
  sidebarLayout(
    sidebarPanel(
      #insert button/slider variables here
    ),
    mainPanel(
      # insert plot here 
    )
  ),
  
  h2("Insert findings/research/etc"),
)


### Page 3 ###

# insert code for buttons/sliders here

z <- tabPanel(
  "Insert title",
  h1("Page 4 Title"),
  sidebarLayout(
    sidebarPanel(
      #insert button/slider variables here
    ),
    mainPanel(
      # insert plot here 
    )
  ),
  
  h2("Insert findings/research/etc"),
)


### Intro Page ###
conclusion <- tabPanel(
  "Conclusion",
  mainPanel(
    h2("Insert Conclusion title"),
    
  )
)





ui <- fluidPage(
  navbarPage(
    inverse = TRUE,
    "Analysis of Vaccinations in Washington State", # app title
    intro_page,
    w,
    x,
    y,
    z,
    conclusion

  ))
