# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
projects = FactoryGirl.create_list(:project, 3)
users    = FactoryGirl.create_list(:active_user, 10)

users.each do |user|
  now   = Time.now.in_time_zone(TIMEZONE)
  edate = (now   - 1.week).end_of_week.to_date
  sdate = (edate - 5.weeks).beginning_of_week.to_date

  (sdate..edate).each do |date|
    FactoryGirl.create :active_log, user:         user,
                                    start_at:     date.to_time + 8.hours,
                                    end_at:       date.to_time + 14.hours,
                                    project_logs: [ FactoryGirl.build(:project_log, log: nil, project: projects.sample) ]
  end
end
