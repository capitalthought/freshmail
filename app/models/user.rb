class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :defaulttimecard
  
  has_many :timecards
  has_many :projects
  has_many :tasks, :through => :projects
  has_one  :fresh_books_account
  
  after_create :initialize_freshbooks_account
  
  def initialize_freshbooks_account
    f = FreshBooksAccount.new
    f.user_id = self.id
    f.save
  end
  
end
