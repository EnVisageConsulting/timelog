# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.transaction do
  projects = FactoryBot.create_list(:project, 3)
  users    = [FactoryBot.create(:admin_user)]
  users    << FactoryBot.create_list(:active_user, 5)
  users.flatten!

  users.each do |user|
    now   = Time.now.in_time_zone(TIMEZONE)
    edate = (now - 1.day).to_date
    sdate = (edate - 4.weeks).beginning_of_week.to_date

    (sdate..edate).each do |date|
      if date.wday > 0 && date.wday < 6 #weekdays
        FactoryBot.create :active_log, user: user, start_at: date.to_time + 8.hours, end_at: date.to_time + 12.hours, project_logs: [ FactoryBot.build(:project_log, log: nil, project: projects.sample) ]
        FactoryBot.create :active_log, user: user, start_at: date.to_time + 13.hours, end_at: date.to_time + 17.hours, project_logs: [ FactoryBot.build(:project_log, log: nil, project: projects.sample) ]
      end
    end
  end
end
