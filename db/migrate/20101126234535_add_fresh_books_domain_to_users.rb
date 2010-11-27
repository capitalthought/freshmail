class AddFreshBooksDomainToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :freshbooksdomain, :string
  end

  def self.down
    remove_column :users, :freshbooksdomain
  end
end
