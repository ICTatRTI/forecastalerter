class SnapshotWorker
  include Sidekiq::Worker

  def perform
    Snapshot.transaction do
      snapshot = Snapshot.take_snapshot
      
      # avoid invalid files 
      if snapshot.forecast_web_file_size > 500
        snapshot.save!
        SnapshotChangeWorker.perform_async snapshot.id 
      end

    end
  end

end