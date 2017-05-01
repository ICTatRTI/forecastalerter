class Snapshot < ApplicationRecord
  include HtmlFileContent

  has_attached_file :forecast_workbook
  has_attached_file :forecast_web
  validates_attachment_content_type :forecast_workbook, 
    content_type: "application/vnd.ms-excel"
  validates_attachment_content_type :forecast_web, 
    content_type: "text/html"

  def self.take_snapshot
    snapshot = Snapshot.new snapshot_time: DateTime.now
    snapshot.download_workbook!
    snapshot.download_web!
    return snapshot
  end

  def previous
    Snapshot.where("snapshot_time < ?", snapshot_time - 12.hours).order("snapshot_time desc").first
  end

  def awards_from_files
    awards = file_to_html_table forecast_workbook
    titles = awards.map {|a| a[Award::HEADERS[:title]]}
    html = Paperclip.io_adapters.for(forecast_web).read
    urls = map_title_urls titles, html
    awards.each do |award|
      award['url'] = urls[award[Award::HEADERS[:title]]]
      if award['url']
        award['usaid_web_id'] = award['url'].split('/').last
      else
        puts "URL not found for award '#{award[Award::HEADERS[:title]]}'"
      end
    end
    return awards
  end

  def changes_from snapshot
    all_changes = []
    current_awards = awards_from_files
    past_awards = snapshot.awards_from_files
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
      if value != past[field] && field != Award::HEADERS[:last_modified_at]
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
      'title' => award[Award::HEADERS[:title]],
      'url' => award['url'],
      'unit' => award[Award::HEADERS[:mbio_name]],
      'type' => award[Award::HEADERS[:type]],
      'sector' => award[Award::HEADERS[:sector]],
      'cost_range' => award[Award::HEADERS[:cost_range]],
      'release_date' => award[Award::HEADERS[:release_date]],
      'award_date' => award[Award::HEADERS[:award_date]],
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

end
