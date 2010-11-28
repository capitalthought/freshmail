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
    out = Array.new
    
    self.projects.each do |p|
      newproject = {"project" => p.name}
      newproject["tasks"] = Hash.new
      p.tasks.each do |t|
        newproject["tasks"][t.name] = 0
      end
      out << newproject
    end
    
    out_string = out.ya2yaml
    self.defaulttimecard = out_string
    self.save
  end
end
