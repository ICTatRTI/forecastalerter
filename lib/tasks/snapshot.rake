namespace :snapshot do

  task :take_and_notify => :environment do |task, args|
    SnapshotWorker.perform_async
  end

  task :take_and_notify_grants => :environment do |task, args|
    GrantsSnapshotWorker.perform_async
  end

end