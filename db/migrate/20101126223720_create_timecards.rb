class CreateTimecards < ActiveRecord::Migration
  def self.up
    create_table :timecards do |t|
      t.date :workdate
      t.text :cardtext
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :timecards
  end
end
