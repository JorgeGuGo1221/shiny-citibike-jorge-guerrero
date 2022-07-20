#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)  

citibike_tripdata <- read_csv("citibike-tripdata.csv")
View(citibike_tripdata)

ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "citibike_tripdata"',
        checkboxGroupInput("show_vars", "Columns in citibike_tripdata to show:",
                           names(citibike_tripdata), selected = names(citibike_tripdata))
      ),
      conditionalPanel(
        'input.dataset === "citibike_tripdata"',
        helpText("Click the column header to sort a column.")
      ),
      conditionalPanel(
        'input.dataset === "citibike_tripdata"',
        helpText("Display 5 records by default.")
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("citibike_tripdata", DT::dataTableOutput("mytable1")),
        tabPanel("citibike_tripdata", DT::dataTableOutput("mytable2")),
        tabPanel("citibike_tripdata", DT::dataTableOutput("mytable3"))
      )
    )
  )
)

server <- function(input, output) {
  
  # choose columns to display
  citibike_tripdata2 = citibike_tripdata[sample(nrow(citibike_tripdata), 1000), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(citibike_tripdata2[, input$show_vars, drop = FALSE])
  })
  
  # sorted columns are colored now because CSS are attached to them
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(citibike_tripdata, options = list(orderClasses = TRUE))
  })
  
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(citibike_tripdata, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}

shinyApp(ui, server)