class AddDetailsToSnapshot < ActiveRecord::Migration[5.0]
 def up
    add_attachment :snapshots, :grantsgov_web
  end

  def down
    remove_attachment :snapshots, :grantsgov_web
  end
end
