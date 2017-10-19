class GrantsSnapshotWorker
  include Sidekiq::Worker

  def perform
    Snapshot.transaction do
      snapshot = Snapshot.take_grants_snapshot
      snapshot.save!
      #GrantsSnapshotChangeWorker.perform_async snapshot.id 
    end
  end

end