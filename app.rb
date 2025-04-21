require "sinatra"
require "sinatra/reloader"
require "http"
require "dotenv/load"

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("API_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("API_KEY")}"

  @raw_response = HTTP.get(api_url)

  @raw_string = @raw_response.to_s

  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("API_KEY")}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  
  @raw_response = HTTP.get(api_url)

  @raw_string = @raw_response.to_s

  @parsed_data = JSON.parse(@raw_string)

  @rate = @parsed_data.fetch("result")
  
  erb(:to_currency)
end
