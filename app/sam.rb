class SamScraper
  require_relative 'browser.rb'

  def self.scrape(duns)
    # duns = "927755033"
    results = {}

    session = Browser.new(:chrome)

    session.visit "https://www.sam.gov/portal/SAM/"
    session.find_all('a[title="Search Records"]').first.click

    # fill out search form
    session.fill_in "DUNS Number Search", with: duns
    session.click_button "Search"

    # open up company record
    # ASSUMPTION: we will only get one valid hit when searching on DUNS
    sleep 3
    detail_link = session.find('input[value="View Details"]')
    detail_link.click

    # Find Registration Status (within Registration Summary)
    # Note xpath "../.." selects parent of parent
    registration_summary_div = session.find('h4', text: "Entity Registration Summary").find(:xpath, '../..')
    html_content = registration_summary_div.find('div.portlet-content')['innerHTML']

    exclusion_summary_div = session.find('h4', text: "Exclusion Summary").find(:xpath, '../..')
    exclusion_html = exclusion_summary_div.find('div.portlet-content')['innerHTML']

    # regex = /<b>Registration Status:<\/b>(.*)<br><b>Activation/
    sub_start = html_content.index("<b>Registration Status:</b>") + 27
    sub_end   = html_content.index("<br><b>Activation Date") - 1
    substring = html_content[sub_start..sub_end].delete("\n").delete("\t").delete('&nbsp\;')

    name_start = html_content.index("<b>Name:&nbsp\;</b>") + 18
    name_end = html_content.index("<br><b>Doing Business") - 1
    name_substring = html_content[name_start..name_end]

    exclusion_start = exclusion_html.index("<b>Active Exclusion Records?&nbsp\;</b>") + 38
    exclusion_end = exclusion_html.index("<br>") - 1
    exclusion_substring = exclusion_html[exclusion_start..exclusion_end]

    output = OpenStruct.new(date:Time.now)
    output.directory = "screenshots/duns/#{duns}"
    FileUtils.mkdir_p(output.directory) unless File.directory?(output.directory)

    output.current_sc = OpenStruct.new(screenshots:[])
    screenshot_filename = "SAM.png"
    session.save_screenshot output.directory + "/" + screenshot_filename
    output.current_sc.screenshots << screenshot_filename
    # Store data

    results['SAM_company_name'] = {}
    results['SAM_registration_status'] = {}
    results['SAM_exclusion_record'] = {}

    results['SAM_company_name']['Name'] = name_substring
    results['SAM_company_name']['screenshot_filename'] = screenshot_filename
    results['SAM_registration_status']['data'] = substring
    results['SAM_registration_status']['screenshot_filename'] = screenshot_filename
    results['SAM_exclusion_record']['active_records'] = exclusion_substring
    results['SAM_exclusion_record']['screenshot_filename'] = screenshot_filename
    return results

  end

end
