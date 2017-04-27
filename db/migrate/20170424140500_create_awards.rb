class CreateAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awards do |t|
      t.string :usaid_web_id
      t.text :mbio_name
      t.text :aa_specialist
      t.text :title
      t.text :description
      t.text :sector
      t.string :code
      t.string :cost_range
      t.text :incumbent
      t.string :type
      t.string :sb_setaside
      t.string :fiscal_year
      t.date :award_date
      t.date :release_date
      t.string :award_length
      t.string :solicitation_number
      t.text :bf_status_change
      t.string :location
      t.datetime :last_modified_at
      t.datetime :removed_at

      t.timestamps
    end
    add_index :awards, :usaid_web_id, :unique => true
  end
end
