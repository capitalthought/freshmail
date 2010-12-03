class FreshBooksAccount < ActiveRecord::Base
  belongs_to :user
  
  after_save :store_projects
  after_save :generate_timecard_text
    
  def store_projects
    if (self.subdomain.nil? && self.token.nil?) then
      logger.debug "Freshbooks not configured"
      return false
    else
      f = FreshBooks::Client.new(self.subdomain + ".freshbooks.com", self.token)
    
      #TODO Breaks if user only has one Freshbooks project
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
      
        self.user.projects << newproject
      end
    end
  end
  
  def generate_timecard_text    
    out = Array.new
    
    self.user.projects.each do |p|
      newproject = {"project" => p.name}
      newproject["tasks"] = Hash.new
      p.tasks.each do |t|
        newproject["tasks"][t.name] = 0
      end
      out << newproject
    end
    
    out_string = out.ya2yaml
    self.user.defaulttimecard = out_string
    self.user.save
  end
end
