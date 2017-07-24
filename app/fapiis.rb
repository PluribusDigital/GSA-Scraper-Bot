class FapiisScraper
  require_relative 'browser.rb'

  def self.scrape(duns)
    # duns = "927755033"
    results = {}

    session = Browser.new(:chrome)

    session.visit "https://www.fapiis.gov/fapiis/index.action"
    session.fill_in 'DUNS/Plus4', with: duns
    session.click_button "Search"

    output = OpenStruct.new(date:Time.now)
    output.directory = "test_output/runs/#{output.date.strftime('%Y%m%d_%H%M%S')}"
    FileUtils.mkdir_p(output.directory) unless File.directory?(output.directory)

    output.current_sc = OpenStruct.new(screenshots:[])
    screenshot_filename = Time.now.strftime('%H%M%S%L') + ".png"
    session.save_screenshot output.directory + "/" + screenshot_filename
    output.current_sc.screenshots << screenshot_filename

    fapiis_data = session.find_all('tr[class="altrow1"]').first.find(:xpath,'..')
    issues_recorded = fapiis_data.text.include?('Yes')

    results['fapiis_data'] = {}
    results['fapiis_data']['Issues Recorded'] = issues_recorded
    results['fapiis_data']['screenshot_filename'] = screenshot_filename

    return results
  end
end
