class CreateFreshBooksAccounts < ActiveRecord::Migration
  def self.up
    create_table :fresh_books_accounts do |t|
      t.string :subdomain
      t.string :token
      
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :fresh_books_accounts
  end
end
