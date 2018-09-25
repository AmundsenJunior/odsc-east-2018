RMarkdown & Shiny

Jared Lander


RMarkdown

save as .Rmd files
set metadata at top of file with '---' to open and close

preview an RMarkdown render with Knit command (Ctrl+Shift+K)

Can add CSS to RMarkdown in the metadata section, which probably corresponds to HTML header section.

Pull up Keyboard Shortcuts Shift+Alt+K

Can use Rmarkdown to create HTML Slideshows

Use packrat for project R dependencies management. Use Docker for system dependencies.

Can use plotly package for interactive plots - same with d3.js
rthreejs for using three.js WebGL 3D rendering in Shiny
Flex Dashboards for non-Shiny interactive HTML pages
Shiny Gallery: http://shiny.rstudio.com/gallery/
  
  
  
  Shiny

> dir()
/home/srussell/dev/r/odsc2018/learningr
> dir.create('app')

Create two files in app/ dir: ui.R server.R
ui.R renders HTML - lots of nested functions calling other functions
server.R backend operation of the server, mostly regular R code within one main function

Needed package shinythemes
> install.packages('shinythemes')

Create your own shiny theme

Create your own ggplot2 theme, modeled off ggthemes template


Download file into app/ dir, via console:
  > download.file('https://www.jaredlander.com/data/FavoriteSpots.json', destfile='app/FavoriteSpots.json')



Create Shiny App - multi-tab - that displays all sessions of R Training: Formal Interface, glmnet, xgboost, RMarkdown, Shiny in RMarkdown, Basic Shiny App, RMarkdown of this full Shiny App

