class SnapshotWorker
  include Sidekiq::Worker

  def perform
    Snapshot.transaction do
      snapshot = Snapshot.take_snapshot
      
      # avoid invalid files 
      if snapshot.forecast_web_file_size > 500
        snapshot.save!
        SnapshotChangeWorker.perform_async snapshot.id 
      else
        logger.info "The snapshot file size is #{snapshot.forecast_web_file_size} and thats too small"
      
      end

    end
  end

end