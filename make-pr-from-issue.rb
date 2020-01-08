#!/usr/bin/env ruby

require 'io/console'

gh_user = ENV['GH_USER']
if gh_user.nil?
  print "What's your github username: "
  gh_user = gets.chomp
else
  puts "Logging in as: #{gh_user}"
end

ORG = 'EnVisageConsulting'
REPO = 'timelog'

puts  "Converting a GitHub issue to a pull request for #{ORG}/#{REPO}"
print "What issue number: "
issue_num = gets.chomp

print "What branch to start from (master or development, maybe?): "
start_branch = gets.chomp

print "What branch to pull from (must be pushed already): "
end_branch = gets.chomp

print "Enter GitHub password: "
userpass = STDIN.noecho(&:gets).chomp

command = %Q(curl --user "#{gh_user}:#{userpass}" --silent --request POST --data '{"issue": #{issue_num}, "head": "#{ORG}:#{end_branch}", "base": "#{start_branch}"}' https://api.github.com/repos/#{ORG}/#{REPO}/pulls)

puts command
puts `#{command}`
