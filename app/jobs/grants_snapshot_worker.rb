class GrantsSnapshotWorker
  include Sidekiq::Worker

  def perform
    GrantsSnapshot.transaction do
      snapshot = GrantsSnapshot.take_snapshot
      snapshot.save!
      GrantsSnapshotChangeWorker.perform_async snapshot.id 
    end
  end

end