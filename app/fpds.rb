class FpdsScraper
  require_relative 'browser.rb'

  def self.scrape(duns)
    # text = 'duns'
    Capybara.register_driver :chrome do |app|
      prefs = {
        download: {
          prompt_for_download: false,
          default_directory: "test_output/tests"
        }
      }
      args = ['--window-size=1024,768']
      Capybara::Selenium::Driver.new(app, browser: :chrome, prefs: prefs, args: args)
    end

    session = Browser.new(:headless_chrome)

    session.visit "https://www.fpds.gov/ezsearch/fpdsportal"
    session.fill_in 'searchText', with: duns
    session.click_button "Go"

    sleep 3

    csv_link = session.find_all('img[title="Export Data as CSV"]').first
    csv_link.click

    # output = OpenStruct.new(date:Time.now)
    # output.directory = "test_output/runs/#{output.date.strftime('%Y%m%d_%H%M%S')}"
    # FileUtils.mkdir_p(output.directory) unless File.directory?(output.directory)
    #
    # output.current_sc = OpenStruct.new(screenshots:[])
    # screenshot_filename = Time.now.strftime('%H%M%S%L') + ".png"
    # session.save_screenshot output.directory + "/" + screenshot_filename
    # output.current_sc.screenshots << screenshot_filename
  end
end

FpdsScraper.scrape(927755033)
