require 'rake/testtask'
# require 'rdoc/task'

# RDoc::Task.new do |rdoc|
#   rdoc.main = "README.rdoc"
#   rdoc.rdoc_files.include("README.rdoc", "lib   /*.rb")
# end

Rake::TestTask.new do |t|
  t.libs << 'tests'
end

desc "Run tests"
task :default => :test


