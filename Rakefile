task default: %w(demo)

@default_driver = 'chrome'
@browsers = %w(safari chrome)

def use_driver(driver)
  ENV['DRIVER'] = driver || @default_driver
end

def demo(driver)
  use_driver driver
  puts "Running a demo using #{ENV['DRIVER']}"
  system('cucumber -t @create_gig')
  #fail 'build failed!' unless $?.exitstatus == 0
end

def parallel_demo(driver)
  use_driver driver
  puts "Running a parallel demo using #{ENV['DRIVER']}"
  system('bundle exec parallel_cucumber ./ -o "-t @l"')
  fail 'build failed!' unless $?.exitstatus == 0
end

task :demo do
  demo 'safari'
end

task :safari do
  demo 'safari'
end

task :firefox do
  demo 'firefox'
end

task :chrome do
  demo 'chrome'
end

task :browserstack do
  demo 'browserstack'
end

task :parallel_safari do
  parallel_demo 'safari'
end

task :parallel_phantomjs do
  parallel_demo 'phantomjs'
end

task :parallel_firefox do
  parallel_demo 'firefox'
end

task :parallel_chrome do
  parallel_demo 'chrome'
end

task :crossbrowser do
  @browsers.each { |browser| Rake::Task[browser].execute }
end

task :parallel_crossbrowser do
  @browsers.each { |browser| Rake::Task['parallel_' + browser].invoke }
end

task :travis => [:demo, :firefox, :parallel_phantomjs, :parallel_firefox]
