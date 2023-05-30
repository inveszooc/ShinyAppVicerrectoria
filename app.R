library(shiny)
library(shinydashboard)
library(tidyverse)
library(here)
library(DT)
library(readxl)

source(here("data","files.R"))

data <- read_csv(file1) |> 
  mutate(enlace = str_remove(enlace, ".*file/d/"),
         enlace = str_remove(enlace, "/view?.*"),
         enlace = str_c("https://drive.google.com/uc?id=",enlace,"&export=download&authuser=0"),
         enlace= str_c("<a href=",
                       enlace,
                       ">Download</a>")) |> 
  select(nombre,cedula,enlace,certificado)

# data2 <- read_csv(file2) |> 
#   mutate(enlace = str_remove(enlace, ".*file/d/"),
#          enlace = str_remove(enlace, "/view?.*"),
#          enlace = str_c("https://drive.google.com/uc?id=",enlace,"&export=download&authuser=0"),
#          enlace= str_c("<a href=",
#                        enlace,
#                        ">Download</a>"),
#          certificado = "IV Encuentro Nacional de Semilleros de Investigación") |> 
#   select(nombre, cedula,enlace,certificado)

# data <- rbind(data1, data2)

ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title = "SIGI ZOCC", titleWidth = 350,
                                    dropdownMenu(type = "notifications", icon = shiny::icon("code"),
                                                 badgeStatus = "info", headerText = "Desarrolladores",
                                                 tags$li(a(href = "https://github.com/srobledog",
                                                           target = "_blank",
                                                           tagAppendAttributes(icon("github")),
                                                           "Sebastian Robledo")),
                                                 tags$li(a(href = "https://github.com/bryanariasq02",
                                                           target = "_blank",
                                                           tagAppendAttributes(icon("github")),
                                                           "Bryan Arias")),
                                                 tags$li(a(href = "https://github.com/camilogs1",
                                                           target = "_blank",
                                                           tagAppendAttributes(icon("github")),
                                                           "Camilo García"))
                                    )
                    ),
dashboardSidebar(
  sidebarMenu(
    menuItemOutput("Certificados")
   
  )
),
dashboardBody(style = "background-color: #ffffff",
              
              fluidPage(
                fluidRow(column(4, align="left", offset = 1, 
                                a(href="https://investigacion.unad.edu.co/",
                                  img(src="banner_1.jpg", height=200, width=500), 
                                  target="_blank")),
                         column(4, align="center", offset = 1, 
                                a(href="https://semilleroszocc.wixsite.com/eventos", 
                                  img(src="logo_1.jpg", height=100, width=100),
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
                options = list(dom = 't'),
                colnames = c("Nombres y Apellidos", "Número de identificación", "Certificado", "Tipo"))
  })
}

shinyApp(ui, server)