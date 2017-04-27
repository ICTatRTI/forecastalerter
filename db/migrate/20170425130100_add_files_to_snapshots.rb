class AddFilesToSnapshots < ActiveRecord::Migration
  def up
    add_attachment :snapshots, :forecast_workbook
    add_attachment :snapshots, :forecast_web
  end

  def down
    remove_attachment :snapshots, :forecast_workbook
    remove_attachment :snapshots, :forecast_web
  end
end