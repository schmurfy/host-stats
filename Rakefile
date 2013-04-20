require 'rubygems'
require 'bundler/setup'
require "bundler/gem_tasks"

task :default => :test

task :test do

  # do not generate coverage report under travis
  unless ENV['TRAVIS']

    require 'simplecov'
    SimpleCov.command_name "E.T."
    SimpleCov.start do
      add_filter ".*_spec"
      add_filter "/specs/helpers/"
      add_filter "/example/"
    end
  end

  require 'eetee'

  runner = EEtee::Runner.new
  runner.run_pattern('specs/**/*_spec.rb')
  runner.report_results()

end

#
# build a single big file for
# easier debugging with Mruby
# 
task :mrbpack do
  # read MRBFILES
  load(File.expand_path('../mrbgem.rake', __FILE__))
  
  test_file_path = File.expand_path('../mruby_test.rb', __FILE__)
  target_files = MRBFILES << test_file_path
  
  FileUtils.mkdir_p('tmp')
  cd 'tmp' do
    File.open('blob.rb', 'w') do |f|
      target_files.each do |path|
        f.puts "# #{path} ==============="
        f.write( File.read(path) )
        f.puts
        f.puts
      end
    end
  end
end
