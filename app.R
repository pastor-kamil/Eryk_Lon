library(shiny)
library(reticulate)
library(markovifyR)
setwd("D:/Eryk_Lon/eryk_lon_generator/eryk_lon_generator")

#system("pip install markovify")

# reticulate::virtualenv_create("python35_env", python = NULL)
# reticulate::virtualenv_install("python35_env", packages = c("markovify"))
# reticulate::use_virtualenv("python35_env", required = TRUE)
# Sys.setenv(RETICULATE_PYTHON = (".virtualenvs/Scripts/python.exe"))
# 
# 
# 
# 
#  reticulate::virtualenv_create(envname = "python_environment", python= "python3")
#  reticulate::use_virtualenv("python_environment", required = FALSE)
# # Sys.setenv(RETICULATE_PYTHON = "//.virtualenvs//python_environment//bin//Scripts")
#  
#  reticulate::virtualenv_create("python35_env", python = "python3")
#  
#  Sys.setenv(RETICULATE_PYTHON = "~/.virtualenvs/python")
#  
use_python(python = "C:/Users/Kamil Pastor/AppData/Local/Programs/Python/Python39/python.exe")


load("teksty.RData")
#load("D:/Eryk_Lon/eryk_lon_generator/eryk_lon_generator/teksty.Rdata")

markov_model <-
  generate_markovify_model(
    input_text = teksty,
    markov_state_size = 2L,
    max_overlap_total = 25,
    max_overlap_ratio = .85
  )


ui <- fluidPage(
   
   # Application title
   titlePanel("Generator tekstów Eryka Łona"),
   fluidRow(
     
     
     column(12,
            p("Opracowane na podstawie artykułów Eryka Łona opublikowanych na stronie internetowej", a(href="https://www.radiomaryja.pl/tag/prof-eryk-lon/", "Radia Maryja"),". Generator tekstu wykorzystuje łańcuchy Markova -", a(href = "https://github.com/abresler/markovifyR", "link"),". Do prawidłowego działania aplikacji wymagana jest zainstalowana wersja Pythona (powyżej 3,6). ") )),

   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        h4("Ustal szczegóły wirtualnego Eryka Łona"),
         sliderInput("counts",
                     "Liczba zdań, które mają się wyświetlać:",
                     min = 1,
                     max = 20,
                     value = 5)
        

      ),
 
      
      # Show a plot of the generated distribution
      mainPanel(
        tableOutput("predykcja")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$predykcja <- renderTable(
   markovify_text(
     markov_model = markov_model,
     maximum_sentence_length = NULL,
     output_column_name = 'Zdania wirtualnego Eryka Łona',
     count = input$counts,
     tries = 200,
     only_distinct = TRUE,
     return_message = FALSE
   )
   )
}

# Run the application 
shinyApp(ui = ui, server = server)

