require 'open-uri'

class Scrape

  def self.call
    doc = Nokogiri::HTML(open("http://www.bcferries.com/current_conditions/actualDepartures.html"))
    byebug
    

  end


end
