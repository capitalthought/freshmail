class AddDefaultTimecardToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :defaulttimecard, :text
  end

  def self.down
    remove_column :users, :defaulttimecard
  end
end
