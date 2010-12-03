class Timecard < ActiveRecord::Base
  belongs_to :user
  
  after_create :publish  
  
  def publish
    f = FreshBooks::Client.new(self.user.freshbooksdomain + ".freshbooks.com", self.user.freshbookstoken)
    input = YAML::load(self.cardtext)
    
    input.each do |project|
      project["tasks"].each do |taskname, hours|
        if hours != 0 then
          f.time_entry.create(:time_entry => {
              :project_id => self.user.projects.find_by_name(project["project"]).freshbooks_id,
              :task_id    => self.user.projects.find_by_name(project["project"]).tasks.find_by_name(taskname).freshbooks_id,
              :hours      => hours,
              :date       => self.workdate
            })
          logger.info "Time Entry created for #{self.user.projects.find_by_name(project["project"]).name} (#{self.user.projects.find_by_name(project["project"]).freshbooks_id}) - #{self.user.projects.find_by_name(project["project"]).tasks.find_by_name(taskname).name} - #{hours} hours"
        end
      end
    end
  end
end
