require 'clean'

desc "Clean all"
task :clean do
  unless ENV["PLUGIN"]
    ENV["PLUGIN"] = "false"
  end
  Rake::Task[:environment].invoke
  [:annotations, :routes, :tests,
   :validations, :views, :code].each do |cleaner|
    Rake::Task["clean:#{cleaner}"].invoke
  end
end
