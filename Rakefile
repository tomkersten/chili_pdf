#!/usr/bin/env ruby
$:.unshift('lib')
require 'redmine_plugin_support'
require 'chili_pdf'
require 'tasks/contributor_tasks'

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'chili_pdf'
  plugin.default_task = [:test]
  plugin.tasks = [:db, :doc, :release, :clean, :test]
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end

Dir["/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

task :default => [:test]

begin
  require 'hoe'
  Hoe.plugin :git

  $hoe = Hoe.spec('chili_pdf') do
    self.readme_file      = 'README.md'
    self.version          = ChiliPDF::VERSION
    self.extra_rdoc_files = FileList['README.md', 'LICENSE', 'History.txt']
    self.summary = "ChiliProject (/Redmine) plugin which implements/enhances PDF-export functionality using the Webkit rendering engine."
    self.extra_deps       = [['wicked_pdf', '0.7.0']]
    self.extra_dev_deps   = []
    developer('Tom Kersten', 'tom@whitespur.com')
  end

  ContributorTasks.new
rescue LoadError
  puts "You are missing the 'hoe' gem, which is used for gem packaging & release management."
  puts "Install using 'gem install hoe' if you need packaging & release rake tasks."
end
