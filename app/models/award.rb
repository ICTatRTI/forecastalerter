class Award < ApplicationRecord

  HEADERS = {
    mbio_name: "Operating Unit",
    aa_specialist: "A&A Specialist / POC",
    title: "Award Title",
    description: "Award Description",
    sector: "Sector",
    code: "NAICS Code",
    cost_range: "Total Estimated Cost/Amount Range",
    incumbent: "Incumbent",
    type: "Award/Action Type",
    sb_setaside: "Small Business Set-Aside",
    fiscal_year: "Fiscal Year of Action",
    award_date:  "Anticipated Award Date",
    release_date: "Anticipated Solicitation Release Date",
    award_length: "Award Length",
    solicitation_number: "Solicitation Number",
    bf_status_change: "Forecast Status Change",
    location: "Location",
    last_modified_at: "Last updated",
    eligibility_criteria: "Eligibility Criteria",
    category_management_contract_vehicle: "Category Management Contract Vehicle",
    :cocreation: "Co-creation"
  }

  def self.find_usaid_web_id web_id
    where("usaid_web_id = ?", web_id).uniq
  end

  def self.find_title title
    where("title = ?", title)
  end

end
