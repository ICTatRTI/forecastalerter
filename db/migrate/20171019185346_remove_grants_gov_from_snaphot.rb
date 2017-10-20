class RemoveGrantsGovFromSnaphot < ActiveRecord::Migration[5.0]
  def change
  	remove_attachment :snapshots, :grantsgov_web
  end
end
