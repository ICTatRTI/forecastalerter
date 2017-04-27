class SnapshotWorker
  include Sidekiq::Worker

  def perform
    Snapshot.transaction do
      snapshot = Snapshot.take_snapshot
      snapshot.save!
      SnapshotChangeWorker.perform_async snapshot.id 
    end
  end

end