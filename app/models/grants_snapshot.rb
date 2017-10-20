class GrantsSnapshot < ApplicationRecord
  include HtmlFileContent

   has_attached_file :grantsgov_web

  validates_attachment_content_type :grantsgov_web, 
    content_type: "application/json"

  def self.take_snapshot
    snapshot = GrantsSnapshot.new snapshot_time: DateTime.now
    snapshot.download_grants!
    return snapshot
  end

  def previous
    GrantsSnapshot.where("snapshot_time < ?", snapshot_time - 12.hours).order("snapshot_time desc").first
  end

  def changes_from snapshot
    all_changes = []
    current_grants = grants_from_json
    past_grants = snapshot.grants_from_json
    past_grant_web_ids = past_grants.map{|a| a['id']}
    # Find the changes for each of the current awards
    current_grants.each do |current_grant|
      grant_id = current_grant['id']
      past_grant = past_grants.find{|pa| pa['id'] == grant_id}
      # Update from past awards
      if past_grant
        all_changes << grant_changes(current_grant, past_grant)
        past_grant_web_ids.delete(grant_id)
      # No matching past award, is new
      else
        all_changes << grant_summary(current_grant, {'new' => true})
      end
    end
    # Past award IDs with no current IDs were removed
    past_grant_web_ids.each do |grant_id|
      past_grant = past_grants.find{|pa| pa['id'] == grant_id}
      all_changes << grant_summary(past_grant, {'removed' => true})
    end
    return all_changes.compact
  end

  def grant_changes current, past
    changes = {}
    current.each do |field, value|
      if value != past[field] 
        changes[field] = {
          'new' => value,
          'past' => past[field]
        }
      end
    end 
    unless changes.empty?
      return grant_summary(current, {'changes' => changes})
    else
      return nil
    end
  end

  def grants_from_json
    json = Paperclip.io_adapters.for(grantsgov_web).read
    return json_to_grants json
  end

  def grant_summary award, props
    return {
      'grant_id' => award['id'],
      'number' => award['number'],
      'title' => award['title'],
      'agencyCode' => award['agencyCode'],
      'agency' => award['agency'],
      'openDate' => award['openDate'],
      'closeDate' => award['closeDate'],
      'oppStatus' => award['oppStatus'],
      'docType' => award['docType'],
    }.merge(props)
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
