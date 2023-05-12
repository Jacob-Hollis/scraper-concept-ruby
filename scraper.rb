require "nokogiri"
require "httparty"
require "csv"

puts "Starting to scrape..."

url = "https://brightdata.com/"

#get the page we want to scrape
response = HTTParty.get(url, {

    headers: { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"},

})

#start scraping
doc = Nokogiri::HTML(response.body)

UseCase = Struct.new(:image, :url, :name)

use_cases = []

use_case_cards = doc.css(".section_cases_row_col_item")

use_case_cards.each do |use_case_card|

    image = use_case_card.at_css("figure img").attribute("data-lazy-src").value

    url = use_case_card.at_css("figure a").attribute("href").value

    name = use_case_card.at_css(".elementor-image-box-content a").text

    use_case = UseCase.new(url, image, name)

    use_cases.push(use_case)

end

# propulate the JSON output file

#File.open("output.json", "wb") do |json|

    #json << JSON.pretty_generate(use_cases.map { |u| Hash[u.each_pair.to_a] })
  
  #end

# populate the CSV output file

CSV.open("output.csv", "wb") do |csv|

    # write the CSV header
  
    csv << ["url", "image", "name"]
  
    # transfrom each use case scraped info to a
  
    # CSV record
  
    use_cases.each do |use_case|
  
      csv << use_case
  
    end
  
end

puts "Done scraping!"