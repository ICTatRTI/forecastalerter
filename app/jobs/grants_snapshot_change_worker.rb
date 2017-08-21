class GrantsSnapshotChangeWorker
  include Sidekiq::Worker

  def perform snapshot_id
    grantssnapshot = GrantsSnapshot.find snapshot_id
    previous_snapshot = grantssnapshot.previous
    changes = grantssnapshot.changes_from previous_snapshot
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