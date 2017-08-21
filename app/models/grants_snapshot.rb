class GrantsSnapshot < ApplicationRecord

  def self.take_snapshot
    snapshot = Snapshot.new snapshot_time: DateTime.now
    snapshot.download_workbook!
    snapshot.download_web!
    return snapshot
  end

  def changes_from snapshot
    all_changes = []
    # To implement
  end

  def self.take_snapshot
    snapshot = GrantsSnapshot.new snapshot_time: DateTime.now
    snapshot.download_web!
    return snapshot
  end

end