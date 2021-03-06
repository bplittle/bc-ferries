require 'open-uri'

class Scrape

  def self.call
    @horseshoe_to_langdale = 'http://orca.bcferries.com:8080/cc/marqui/sailingDetail.asp?route=03&dept=HSB'
    @langdale_to_horseshoe = 'http://orca.bcferries.com:8080/cc/marqui/sailingDetail.asp?route=03&dept=LNG'
    d = Date.today
    if d.friday? || d.saturday? || d.sunday?
      scrape(@horseshoe_to_langdale)
      scrape(@langdale_to_horseshoe)
    end
  end

  private

  def self.scrape(route_url)
    parent = Nokogiri::HTML(open(route_url))
    route_origin = route_url.match(/...$/).to_s
    sailings = parent.css('select option')

    sailings.each do |option|
      tail = option.attribute('value').value
      prefix = route_url.split('sailingDetail').first
      new_url = prefix + tail
      break unless get_data(new_url, route_origin)
    end
  end

  def self.get_data(url, route_origin)
    doc = Nokogiri::HTML(open(url))
    sailing_time_ampm = doc.css('span.white-header-bold-lg').first.text.split('Details: ').last
    if sailing_time_ampm.include? 'PM'
      hours = sailing_time_ampm.split(':').first.to_i
      hours += 12
      sailing_time = hours.to_s + ':' + sailing_time_ampm.split(':').last[0, 2]
      sailing_time +=  " " + sailing_time_ampm[/\(.*\)/] if sailing_time_ampm[/\(.*\)/]
    else
      sailing_time = sailing_time_ampm[0, 5]
      sailing_time +=  " " + sailing_time_ampm[/\(.*\)/] if sailing_time_ampm[/\(.*\)/]
    end

    detail_url_tail = doc.css('script')[2].children.first.inspect.match(/DeckSpace_pop.*tm=..../).to_s
    detail_url_prefix = url.split('sailingDet').first
    detail_url = detail_url_prefix + detail_url_tail
    details = Nokogiri::HTML(open(detail_url))
    cars = details.css('table tr td table tr td table').first['width'].to_i
    trucks = details.css('table tr td table tr td table').last['width'].to_i
    # ferry is 77% cars, 23% trucks
    total = (cars * 0.77 + trucks * 0.23).to_i
    if total > 0
      c = Condition.new(
        sailing_time: sailing_time,
        cars_percentage: cars,
        trucks_percentage: trucks,
        total_percentage: total,
        route_origin: route_origin
      )
      if c.save && total > 7 # stop if total is 7% or less (next sailing will have so little)
        return true
      else
        return false
      end
    else
      return false
    end
  end


end
