class CreateSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :snapshots do |t|
      t.datetime :snapshot_time
      t.json :awards_changes

      t.timestamps
    end
  end
end
