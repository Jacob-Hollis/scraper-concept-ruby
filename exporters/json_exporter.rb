def export_json(use_cases)
    #write each line of data to the file
    File.open("output.json", "wb") do |json|
        json << JSON.pretty_generate(use_cases.map { |u| Hash[u.each_pair.to_a] })
    end
end