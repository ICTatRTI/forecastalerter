class AddGrantsGovtoGrantsSnaphot < ActiveRecord::Migration[5.0]
def up
    add_attachment :grants_snapshots, :grantsgov_web
  end

  def down
    remove_attachment :grants_snapshots, :grantsgov_web
  end
end
