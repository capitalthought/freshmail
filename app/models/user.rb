class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :freshbookstoken, :freshbooksdomain,
                  :defaulttimecard
  
  has_many :timecards
  
  def generate_timecard_text
    f = FreshBooks::Client.new(self.freshbooksdomain + ".freshbooks.com", self.freshbookstoken)
    projects = f.project.list["projects"]["project"]
    
    out = Array.new
    
    projects.each do |p|
        x = { "name" => p["name"], "id" => p["project_id"]}
        tasks = f.task.list :project_id => p["project_id"]
        x["tasks"] = Array.new
        tasks["tasks"]["task"].each do |t|
          taskname = t["name"]
          taskname.gsub!(/ /, '_')
          x["tasks"] << {taskname => 0}
        end
        out << x      
    end
    out_string = out.ya2yaml.gsub(/- \n    /,'-')
    self.defaulttimecard = out_string
  end
end
