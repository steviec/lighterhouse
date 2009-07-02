class AddLighthouseIdAndNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :lighthouse_id, :integer
  end

  def self.down
    remove_column :users, :lighthouse_id
    remove_column :users, :name
  end
end
