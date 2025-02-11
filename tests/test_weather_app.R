library('shinytest2')
library('mockery')

app <- AppDriver$new(variant = shinytest2::VariantShinyDriver)

# Mock the fetch_weather function to simulate API response
mocked_fetch_weather <- function(city) {
  return(list(
    main = list(temp = 290.5),
    weather = list(list(description = "clear sky"))
  ))
}

# Replace the fetch_weather function in the app's environment with the mocked version
test_that("weather API integration works", {
  app$set_inputs(city = "London")
  stub(app$server, "fetch_weather", mocked_fetch_weather)
  
  # Simulate clicking the "Get Weather" button
  app$click("get_weather")
  
  # Check if the weather information is displayed correctly
  app$wait_for_value("weather", "Temperature: 290.5 K\nWeather: clear sky")
})

test_that("empty city input shows error message", {
  app$set_inputs(city = "")
  app$click("get_weather")
  
  # Check if an error message is displayed when city input is empty
  app$wait_for_value("weather", "Error: City cannot be empty")
})
