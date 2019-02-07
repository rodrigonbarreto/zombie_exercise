# This migration is in case someone saves in database a null value, raise a error on database.
class RemoveAllowNullNameInTables < ActiveRecord::Migration[5.1]
  def up
    change_column :armors, :name, :string, null: false
    change_column :zombies, :name, :string, null: false
    change_column :weapons, :name, :string, null: false

  end

  def down
    change_column :armors, :name, :string, null: true
    change_column :zombies, :name, :string, null: true
    change_column :weapons, :name, :string, null: true
  end
end
