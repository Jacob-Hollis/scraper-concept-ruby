def export_csv(use_cases)
    CSV.open("output.csv", "wb") do |csv|
        # write the CSV header 
        csv << ["url", "image", "name"]
        #write each line of data
        use_cases.each do |use_case|
            csv << use_case
        end
    end
end