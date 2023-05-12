require "nokogiri"
require "httparty"
require "csv"
require_relative "exporters/csv_exporter"
require_relative "exporters/json_exporter"

puts "Starting to scrape..."

url = "https://brightdata.com/"

#get the page we want to scrape
response = HTTParty.get(url, {
    headers: { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"},
})

#start scraping
doc = Nokogiri::HTML(response.body)

#define our data structure
UseCase = Struct.new(:image, :url, :name)

#initialize the list of data
use_cases = []

#find the cards we want to pull from in css
use_case_cards = doc.css(".section_cases_row_col_item")

#for each card
use_case_cards.each do |use_case_card|
    #grab attributes and save to variable
    image = use_case_card.at_css("figure img").attribute("data-lazy-src").value
    url = use_case_card.at_css("figure a").attribute("href").value
    name = use_case_card.at_css(".elementor-image-box-content a").text

    #store to the list
    use_case = UseCase.new(url, image, name)
    use_cases.push(use_case)
end

# populate the JSON output file
export_json(use_cases)

# populate the CSV output file
export_csv(use_cases)

puts "Done scraping!"