class AddTargetNameToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :target_name, :string
  end
end
