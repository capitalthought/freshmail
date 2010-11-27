class Timecard < ActiveRecord::Base
  belongs_to :user
    
  def generate_timecard
    f = FreshBooks::Client.new(self.user.freshbooksdomain + ".freshbooks.com", self.user.freshbookstoken)
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
  end
end
