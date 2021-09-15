library(shiny)
library(shinydashboard)
library(tidyverse)
library(here)
library(DT)
library(plotly)
library(readxl)
library(crosstalk)


data <- read_csv("https://docs.google.com/spreadsheets/d/1RlqYP8SEnJAQR00BHeyjovjB4Bm6PduT77ApeaekzwM/export?format=csv&gid=0") |> 
  mutate(enlace = str_c("https://drive.google.com/uc?id=",id,"&export=download&authuser=0"),
         enlace= str_c("<a href=",
                    enlace,
                    ">Download</a>"),
         certificado = "XXIV Encuentro Nacional de Investigaciones") |> 
  select(cedula,enlace,certificado)

         
ui <- dashboardPage(
    dashboardHeader(title = "Investigación"),
    dashboardSidebar(
        sidebarMenu(
            menuItemOutput("certificado")
        )
    ),
    dashboardBody(
        fluidPage(
        column(8, align="center", offset = 2,
               textInput("txt", "Ingrese Número de Identificación"),
               actionButton("button", "Buscar")
        ),
       dataTableOutput('salida')))
)

server <- function(input, output) {
    output$certificado <- renderMenu({
        menuItem("Certificado", icon = icon("book-open"))
    })
    
    dato <- eventReactive(input$button,
      (input$txt),
      ignoreNULL = FALSE,ignoreInit = FALSE
    )
    
    output$salida <- renderDT({
      data |> filter(cedula == dato()) |> 
        datatable(escape = FALSE,
                  colnames = c("Número Identificación", "Certificado", "Tipo"))
    })
}

shinyApp(ui, server)