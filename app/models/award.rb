class Award < ApplicationRecord

  HEADERS = {
    mbio_name: "M/B/IO Name",
    aa_specialist: "A&A Specialist",
    title: "Award Title",
    description: "Award Description",
    sector: "Sector",
    code: "Code",
    cost_range: "Total Estimated Cost/Amount Range",
    incumbent: "Incumbent",
    type: "Award/Action Type",
    sb_setaside: "Small Business Set Aside",
    fiscal_year: "Fiscal Year of Action",
    award_date:  "Anticipated Award Date",
    release_date: "Anticipated Solicitation Release Date",
    award_length: "Award Length",
    solicitation_number: "Solicitation Number",
    bf_status_change: "Business Forecast Status Change",
    location: "Location",
    last_modified_at: "Last Modified Date"
  }

  def self.find_usaid_web_id web_id
    where("usaid_web_id = ?", web_id).uniq
  end

  def self.find_title title
    where("title = ?", title)
  end

end
