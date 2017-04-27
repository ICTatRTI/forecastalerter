namespace :snapshot do

  task :take_and_notify => :environment do |task, args|
    SnapshotWorker.perform_async
  end

end