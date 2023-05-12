require "nokogiri"
require "httparty"
require "csv"
require 'open-uri'
require 'net/http'

puts "Starting to scrape..."

city = "Columbia"
state = "Missouri"
country = "United-States"
nights = 1

url = "https://www.airbnb.com/s/#{city}--#{state}--#{country}/homes?tab_id=home_tab&refinement_paths%5B%5D=%2Fhomes&flexible_trip_lengths%5B%5D=one_week&price_filter_input_type=2&price_filter_num_nights=#{nights}&channel=EXPLORE&date_picker_type=calendar&query=Columbia%2C%20MO&place_id=ChIJyYKBu_Or3IcRIG-9ui1pEaA&checkin=2023-03-31&checkout=2023-04-01&adults=2&source=structured_search_input_header&search_type=filter_change&pagination_search=true&price_min=10&price_max=86"

#get the page we want to scrape
#response = HTTParty.get(url, {

    #headers: { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"},

#})

response = URI.open(url)

#start scraping
doc = Nokogiri::HTML(response.body)

UseCase = Struct.new(:url)

use_cases = []

use_case_cards = doc.css(".c4mnd7m.dir.dir-ltr")

use_case_cards.each do |use_case_card|

    #image = use_case_card.at_css("figure img").attribute("data-lazy-src").value

    #url = use_case_card.at_css("figure a").text

    url = use_case_card.at_css("cy5jw6o.dir.dir-ltr a").attribute("href").value

    use_case = UseCase.new(url)

    use_cases.push(use_case)

end

# propulate the JSON output file

#File.open("output.json", "wb") do |json|

    #json << JSON.pretty_generate(use_cases.map { |u| Hash[u.each_pair.to_a] })
  
  #end

# populate the CSV output file

CSV.open("output.csv", "wb") do |csv|

    # write the CSV header
  
    csv << ["url"]
  
    # transfrom each use case scraped info to a
  
    # CSV record
  
    use_cases.each do |use_case|
  
      csv << use_case
  
    end
  
end

puts "Done scraping!"