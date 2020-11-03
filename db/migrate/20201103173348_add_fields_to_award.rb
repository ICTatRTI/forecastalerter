class AddFieldsToAward < ActiveRecord::Migration[5.2]
  def change
    add_column :awards, :eligibility_criteria, :string
    add_column :awards, :category_management_contract_vehicle, :string
    add_column :awards, :cocreation, :string
  end
end
