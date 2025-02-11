library('shiny')
library('httr')
library('jsonlite')

ui <- fluidPage(
  titlePanel("Weather App"),
  textInput("city", "Enter city name", "London"),
  actionButton("get_weather", "Get Weather"),
  verbatimTextOutput("weather")
)

server <- function(input, output) {
  
  api_key <- "your_api_key_here"  # Replace with your actual OpenWeatherMap API key
  
  fetch_weather <- function(city) {
    url <- paste0("http://api.openweathermap.org/data/2.5/weather?q=", city, "&appid=", api_key)
    response <- GET(url)
    content <- content(response, "text")
    weather_data <- fromJSON(content)
    return(weather_data)
  }
  
  observeEvent(input$get_weather, {
    weather_data <- fetch_weather(input$city)
    output$weather <- renderText({
      paste("Temperature:", weather_data$main$temp, "K\n",
            "Weather:", weather_data$weather[[1]]$description)
    })
  })
}

shinyApp(ui, server)
