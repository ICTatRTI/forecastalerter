class GrantsSnapshotChangeWorker
  include Sidekiq::Worker

  def perform snapshot_id
    snapshot = GrantsSnapshot.find snapshot_id
    previous_snapshot = snapshot.previous
    
    changes = snapshot.changes_from previous_snapshot
    unless changes.empty?
      AwardChangesMailer.grants_changed(changes, snapshot.snapshot_time, previous_snapshot.snapshot_time).deliver_now
      logger.info "Queued snapshot #{snapshot.id} changes at {snapshot.snapshot_time}"
  	else
      logger.info "Changes are empty for snapshot #{snapshot.id}:#{snapshot.snapshot_time}"
    end
  end

end