class Timecard < ActiveRecord::Base
  belongs_to :user
  
  after_initialize :defaults

  def defaults
    self.cardtext||= "foo"
  end
end
