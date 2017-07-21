require_relative 'browser.rb'

duns = "927755033"
results = {}

session = Browser.new(:headless_chrome)

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
# regex = /<b>Registration Status:<\/b>(.*)<br><b>Activation/
sub_start = html_content.index("<b>Registration Status:</b>") + 27
sub_end   = html_content.index("<br><b>Activation Date") - 1
substring = html_content[sub_start..sub_end].delete("\n").delete("\t").delete('&nbsp\;')
# Store data
results['SAM_registration_status'] = {}
results['SAM_registration_status']['data'] = substring

# grab screenshot
# ...
# save screenshot example: https://github.com/MSOL-Inc/FDIC-LIX/blob/develop/acceptance_tests/features/support/hooks.rb#L22
# results['SAM_registration_status']['screenshot'] = filename #TBD!

# byebug

puts results
