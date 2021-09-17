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
  dashboardHeader(title = "Vicerrectoría de Investigaciones", titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItemOutput("Certificados")
    )
  ),
  dashboardBody(style = "background-color: #ffffff",
                
                fluidPage(
                  fluidRow(column(4, align="left", offset = 1, 
                                  a(href="https://www.funlam.edu.co/",
                                    img(src="banner.jpeg", height=200, width=500), 
                                    target="_blank")),
                           column(4, align="center", offset = 1, 
                                  a(href="https://www.funlam.edu.co/modules/centroinvestigaciones/", 
                                    img(src="logo.jpg", height=100, width=100),
                                    target="_blank"))),
                  fluidRow(
                    column(8, align="center", offset = 2,
                           textInput("txt", "Ingrese Número de Identificación"),
                           actionButton("button", "Buscar")
                    ),
                    dataTableOutput('salida'),
                    hr()
                  ) 
                )    
  )
)

server <- function(input, output) {
  
  output$Certificados <- renderMenu({
    menuItem("Certificados", icon = icon("book-open"))
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