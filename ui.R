library(shiny)
library(shinythemes)

mlTrainingPanel <- tabPanel(
    title = 'Machine Learning Training'
)

shinyTrainingPanel <- tabPanel(
    title = 'Shiny & RMarkdown Training'
)

rPackageSessionPanel <- tabPanel(
    title = 'R Packages Session'
)

kerasWorkshopPanel <- tabPanel(
    title = 'Keras Workshop'
)

pachydermPanel <- tabPanel(
    title = 'Pachyderm Demo'
)

odsceastPanel <- tabPanel(
    title = 'ODSC East 2018 Sessions'
)



statePanel <- tabPanel(
    title = 'State Info',
     # select input of state from dropdown
    selectInput(
        inputId = 'StateSelector',
        label = 'Choose a state',
        choices = list('NY', 'NJ', 'MA', 'TX')
    ),
    # display output of selected state
    textOutput(
        outputId = 'DisplayState'
    )
)

plotPanel <- tabPanel(
    title = 'Simple Plot',
    fluidRow( # twitter bootstrap framework being used creating two sections
        column(
            
            width=3,
            selectInput(
                inputId = 'CarColumn',
                label = 'Please choose a column to plot',
                choices = names(mtcars)
            )
        ),
        column(
            width=9,
            plotOutput(outputId='CarHist')
        )
    )
)

pizzaPanel <- tabPanel(
    title='Pizza',
    fluidRow(
        column(
            width=6,
            DT::dataTableOutput(outputId='PizzaTable')
        ),
        column(
            width=6,
            leaflet::leafletOutput(outputId='PizzaMap')
        )
    )
)
navbarPage(
    title='ODSC East 2018',
    selected='Machine Learning Training', # default tab to open on loading page
    theme=shinytheme(theme='spacelab'), # set a shiny theme
    # themeSelector(), # show a dropdown selector of shiny themes available
    mlTrainingPanel,
    shinyTrainingPanel,
    rPackageSessionPanel,
    kerasWorkshopPanel,
    pachydermPanel,
    odsceastPanel
)
