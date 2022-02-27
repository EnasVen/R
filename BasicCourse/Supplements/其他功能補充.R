#### Additonal Part ####

#### 1.flow control ####
aqm <- melt(airquality, id.vars = c("Month", "Day") , na.rm = T)
dcast(aqm, Month ~ variable, mean , subset = .(value >= 40))

aqm2 <- aqm[aqm$value>=40,]
aqm2 %>% dplyr::filter(variable=='Ozone' , Month==5) %>% dplyr::select(value) %>% colMeans(.)

chickwts %>% dplyr::group_by(feed) %>% dplyr::summarise(M= sprintf( '%0.3f' ,mean(weight))  )

#### 2.flow control ####

tryCatch(
  {
    matrix(1:5)%*% matrix(1:12 , nrow=3)
  },
  warning = function(x){
    message("Test warning message:")
    message(paste(x,"\n"))
    return(123)
  },
  error = function(x){
    message("Test error message:")
    message(paste(x,"\n"))
    return(456)
  }

)

#### 3.plotly ####
library(plotly)

fig <- plot_ly(mtcars, x = ~wt, y = ~hp, z = ~qsec,
               marker = list(color = ~mpg, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE))
fig <- fig %>% add_markers()
fig <- fig %>% layout(scene = list(xaxis = list(title = 'Weight'),
                                   yaxis = list(title = 'Gross horsepower'),
                                   zaxis = list(title = '1/4 mile time')),
                      annotations = list(
                        x = 1.13,
                        y = 1.05,
                        text = 'Miles/(US) gallon',
                        xref = 'paper',
                        yref = 'paper',
                        showarrow = FALSE
                      ))
fig


#### 4.grid plot ####
library(ggplot2)
p1 <- qplot(mpg, wt, data = mtcars, colour = cyl)
p2 <- qplot(mpg, data = mtcars) + ggtitle("title")
p3 <- qplot(mpg, data = mtcars, geom = "dotplot")
p4 <-
  p1 + facet_wrap( ~ carb, nrow = 1) + theme(legend.position = "none") +
  ggtitle("facetted plot")

grid.arrange(p1, p2, nrow = 1)

grid.arrange(
  p3,
  p3,
  p3,
  nrow = 1,
  top = "Title of the page"
)


