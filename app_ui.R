#UI 
library(shiny)
library(ggplot2)



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



### Page 2 ###

# insert code for buttons/sliders here

x <- tabPanel(
  "Insert title",
  h1("Page 2 Title"),
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
    "Info 478 Final Project", # app title
    intro_page,
    w,
    x,
    y,
    z,
    conclusion

  ))
