class AddFreshBooksApiTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :freshbookstoken, :string
  end

  def self.down
    remove_column :users, :freshbookstoken
  end
end
