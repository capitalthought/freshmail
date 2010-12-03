class DropFreshBooksDataFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :freshbooksdomain
    remove_column :users, :freshbookstoken
  end

  def self.down
    add_column :users, :freshbookstoken, :string
    add_column :users, :freshbooksdomain, :string
  end
end
