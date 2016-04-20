desc "Scrape for BC ferries schedule"
task :scrape_bc_ferries => :environment do
  Rails.logger.debug "Scraping Ferries Site..."
  Scraper.call
  Rails.logger.debug "done."
end

# desc "Fix attributes"
# task :moar => :environment do
#   AddMoreStats.call
# end
