class SnapshotChangeWorker
  include Sidekiq::Worker

  def perform snapshot_id
    snapshot = Snapshot.find snapshot_id
    previous_snapshot = snapshot.previous
    changes = snapshot.changes_from previous_snapshot
    unless changes.empty?
      User.all.each do |user|
        AwardChangesMailer.awards_changed(user, changes, snapshot.snapshot_time, previous_snapshot.snapshot_time).deliver_now
        logger.info "Queued snapshot #{snapshot.id} changes to #{user.email}"
      end
    else
      logger.info "Changes are empty for snapshot #{snapshot.id}:#{snapshot.snapshot_time}"
    end
  end

end