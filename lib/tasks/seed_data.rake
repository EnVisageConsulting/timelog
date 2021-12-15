task :seed_data => :environment do
  User.find_by(email: "test@test.com").delete
  user = User.new(first: "Test", last: "User", email: "test@test.com", password: "Testing123", role: 1, activated_at: Time.now)
  user.save!

  Project.where(name: "Test Project").delete_all
  project = Project.new(name: "Test Project")
  project.save!

  (DateTime.now - 1.days).downto(DateTime.now - 31.days) do |day|
    if day.wday > 0 && day.wday < 6 #weekdays
      start_at = DateTime.new(day.year, day.month, day.day, 8, 0, 0, day.zone)
      end_at = DateTime.new(day.year, day.month, day.day, 16, 0, 0, day.zone)

      log = Log.new(user_id: user.id, start_at: start_at, end_at: end_at, activated: true)

      project_log = log.project_logs.build(log_id: log.id, project_id: project.id, hours: 9, total_allocation: 1, billable_allocation: 1, description: "Log for #{day}", non_billable: false)
      log.save!
      project_log.save!
    end
  end
end
