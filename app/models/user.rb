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
  has_many :projects
  has_many :tasks, :through => :projects
  
  def store_projects
    f = FreshBooks::Client.new(self.freshbooksdomain + ".freshbooks.com", self.freshbookstoken)
    
    projects = f.project.list["projects"]["project"]
    
    projects.each do |p|
      newproject = Project.new
      newproject.name = p["name"]
      newproject.freshbooks_id = p["project_id"]
      
      tasks = f.task.list :project_id => newproject.freshbooks_id
      tasks = tasks["tasks"]["task"]
      
      tasks.each do |t|
        newtask = Task.new
        newtask.name = t["name"]
        newtask.freshbooks_id = t["task_id"]
        
        newproject.tasks << newtask
      end
      
      self.projects << newproject
    end
    
  end
  
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
