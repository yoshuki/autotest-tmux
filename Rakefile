require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "autotest-tmux"
    gem.summary = %Q{displays autotest/autospec progress on tmux status-right.}
    gem.description = %Q{displays autotest/autospec progress on tmux status-right.}
    gem.email = "yoshuki@saikyoline.jp"
    gem.homepage = "http://github.com/yoshuki/autotest-tmux"
    gem.authors = ["MIKAMI Yoshiyuki"]
    gem.add_development_dependency "autotest", ">= 4.4.1"
    gem.add_development_dependency "rspec", ">= 2.0.0"
    gem.add_dependency "autotest"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['-c', '-f documentation', '-r ./spec/spec_helper.rb']
  t.pattern = 'spec/**/*_spec.rb'       # same as default
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov_opts = nil                     # same as default
  t.pattern = 'spec/**/*_spec.rb'       # same as default
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "autotest-tmux #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
