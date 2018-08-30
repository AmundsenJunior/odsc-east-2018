library(shiny)
library(ggplot2)
library(ggthemes)
library(magrittr)
library(leaflet)

# load pizza data downloaded
pizza <- jsonlite::fromJSON('FavoriteSpots.json') %>% tidyr::unnest()

# shiny server runs an anonymous lambda function
shinyServer(function(input, output, session) {
    # all inputs from user on ui are stored in a list called 'input'
    # all outputs to be pushed back to ui by server are stored in 'output' list
    
    output$DisplayState <- renderText(input$StateSelector)
    
    output$CarHist <- renderPlot({ # one line input only needs parens, but multiline would need curly braces, so include by default as good practice
        ggplot(mtcars, aes_string(x=input$CarColumn)) + geom_histogram() + theme_economist()
    })
    
    output$PizzaTable <- DT::renderDataTable({
        DT::datatable(
            pizza, rownames = FALSE
        )
    })
    
    output$PizzaMap <- renderLeaflet({
        leaflet() %>% 
            addTiles() %>% 
            addMarkers(
                lng = ~ longitude, 
                lat = ~ latitude, 
                popup = ~ Name,
                data = pizza %>% dplyr::slice( # add data and hightlight items on map selected on table
                    as.integer(
                        # input$PizzaTable_rows_selected # the output PizzaTable is also available as an input back to the app
                        input$PizzaTable_rows_all # display all rows shown on screen, which gets filtered with search terms
                    )
                )
            )
    })
})
