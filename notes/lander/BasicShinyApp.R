# Initial Shiny App


# ui.R

library(shiny)

# all ui for shiny must be defined in a fluidPage function, where the page rendering functions are just a list of arguments to fluidPage
fluidPage(
    title='Intermediate Shiny at ODSC East 2018',
    
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
# to run the app, Ctrl+Shift+Enter


# server.R

library(shiny)

# shiny server runs an anonymous lambda function
shinyServer(function(input, output, session) {
    # all inputs from user on ui are stored in a list called 'input'
    # all outputs to be pushed back to ui by server are stored in 'output' list
    
    output$DisplayState <- 
        renderText(input$StateSelector)
})