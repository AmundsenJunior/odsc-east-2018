library(magrittr)
library(leaflet)

download.file('https://www.jaredlander.com/data/FavoriteSpots.json', destfile='app/FavoriteSpots.json')

pizza <- jsonlite::fromJSON('app/FavoriteSpots.json')
pizza
pizza$Coordinates # nested columns in data frame

pizza <- jsonlite::fromJSON('app/FavoriteSpots.json') %>% tidyr::unnest() # needed magrittr for piping

pizza

# Insert pipe with Ctrl+Shift+M

# Learn to play with leaflet
leaflet() %>% 
    addTiles() %>% 
    addMarkers(
        lng = ~ longitude, 
        lat = ~ latitude, 
        popup = ~ Name,
        data = pizza
    )
