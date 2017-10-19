class Snapshot < ApplicationRecord
  include HtmlFileContent

  has_attached_file :forecast_workbook
  has_attached_file :forecast_web
  has_attached_file :grantsgov_web

  validates_attachment_content_type :forecast_workbook, 
    content_type: "application/vnd.ms-excel"
  validates_attachment_content_type :forecast_web, 
    content_type: "text/html"
  validates_attachment_content_type :grantsgov_web, 
    content_type: "application/json"

  def self.take_snapshot
    snapshot = Snapshot.new snapshot_time: DateTime.now
    snapshot.download_workbook!
    snapshot.download_web!
    return snapshot
  end

  def self.take_grants_snapshot
    snapshot = Snapshot.new snapshot_time: DateTime.now
    snapshot.download_grants!
    return snapshot
  end

  def previous
    Snapshot.where("snapshot_time < ?", snapshot_time - 12.hours).order("snapshot_time desc").first
  end

  # Pull out the awards from the files into a hash of properties, 
  # including the usaid_web_ids from the search results.
  def awards_from_files
    awards = file_to_html_table forecast_workbook
    titles = awards.map {|a| a['title']}
    html = Paperclip.io_adapters.for(forecast_web).read
    urls = map_title_urls titles, html
    awards.each do |award|
      award['url'] = urls[award['title']]
      if award['url']
        award['usaid_web_id'] = award['url'].split('/').last
      else
        puts "URL not found for award '#{award['title']}'"
      end
    end
    return awards
  end

  def awards_from_html
    html = Paperclip.io_adapters.for(forecast_web).read
    return html_to_awards html
  end

  # Do any awards have no usaid_web_ids?
  def awards_without_usaid_web_ids
    awards = awards_from_html
    return awards.select {|a| a['usaid_web_id'].blank?}
  end

  def changes_from snapshot
    all_changes = []
    current_awards = awards_from_html
    past_awards = snapshot.awards_from_html
    past_award_web_ids = past_awards.map{|a| a['usaid_web_id']}
    # Find the changes for each of the current awards
    current_awards.each do |current_award|
      usaid_web_id = current_award['usaid_web_id']
      past_award = past_awards.find{|pa| pa['usaid_web_id'] == usaid_web_id}
      # Update from past awards
      if past_award
        all_changes << award_changes(current_award, past_award)
        past_award_web_ids.delete(usaid_web_id)
      # No matching past award, is new
      else
        all_changes << award_summary(current_award, {'new' => true})
      end
    end
    # Past award IDs with no current IDs were removed
    past_award_web_ids.each do |usaid_web_id|
      past_award = past_awards.find{|pa| pa['usaid_web_id'] == usaid_web_id}
      all_changes << award_summary(past_award, {'removed' => true})
    end
    return all_changes.compact
  end

  def award_changes current, past
    changes = {}
    current.each do |field, value|
      if value != past[field] && field != 'last_modified_at'
        changes[field] = {
          'new' => value,
          'past' => past[field]
        }
      end
    end 
    unless changes.empty?
      return award_summary(current, {'changes' => changes})
    else
      return nil
    end
  end

  def award_summary award, props
    return {
      'usaid_web_id' => award['usaid_web_id'],
      'title' => award['title'],
      'url' => award['url'],
      'unit' => award['mbio_name'],
      'type' => award['type'],
      'sector' => award['sector'],
      'cost_range' => award['cost_range'],
      'release_date' => award['release_date'],
      'award_date' => award['award_date'],
    }.merge(props)
  end

  def download_workbook!
    uri = URI(USAID_URLS[:forecast_workbook])
    self.forecast_workbook = StringIO.new Net::HTTP.get(uri)
    self.forecast_workbook_file_name = File.basename(uri.path)
    self.forecast_workbook_content_type = "application/vnd.ms-excel"
  end

  def download_web!
    uri = URI(USAID_URLS[:forecast_results])
    self.forecast_web = StringIO.new Net::HTTP.get(uri)
    self.forecast_web_file_name = File.basename(uri.path)
    self.forecast_web_content_type = "text/html"
  end

  def download_grants!
    uri = URI(USAID_URLS[:grants_results])
    
    params = {:agencies => "USAID|USAID-*", :startRecordNum => 0, :oppStatuses => "forecasted|posted", :sortBy => "openDate|desc"}
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.body = params.to_json
    resp = http.request(request)

    self.grantsgov_web = StringIO.new resp.body
    self.grantsgov_web_file_name = File.basename(uri.path)
    self.grantsgov_web_content_type = "application/json"
  end

end
