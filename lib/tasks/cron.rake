desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  mylist = Mylist.new
  mylist.create_mylist
  puts "done."
end