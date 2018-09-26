library(shiny)
library(shinythemes)

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
    title='Intermediate Shiny at ODSC East 2018',
    selected='Pizza', # default tab to open on loading page
    theme=shinytheme(theme='spacelab'), # set a shiny theme
    # themeSelector(), # show a dropdown selector of shiny themes available
    tabPanel(
        title = 'First Page',
        'Hi'
    ),
    tabPanel(
        title = 'Second Page',
        'Hello'
    ),
    statePanel,
    plotPanel,
    pizzaPanel
)
