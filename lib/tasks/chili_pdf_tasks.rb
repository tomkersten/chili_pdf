require 'rake'
require 'rake/tasklib'

class ChiliPDFTasks < Rake::TaskLib
  def initialize
    define
  end

  def define
    namespace :chili_pdf do
      desc "Install ChiliPDF plugin (include assets, etc)"
      task :install => [:symlink_assets]

      desc "Uninstall ChiliPDF plugin (remove assets, etc)"
      task :uninstall => [:environment] do
        puts "Removing link to ChiliPDF assets (stylesheets, js, etc)..."
        remove_symlink asset_destination_dir

        puts post_uninstall_steps
      end

      task :symlink_assets => [:environment] do
        # HACK: Symlinks the files from plugindir/assets to the appropriate place in
        # the rails application
        remove_symlink(asset_destination_dir)
        puts "Symlinking assets (stylesheets, etc)..."
        add_symlink asset_source_dir, asset_destination_dir
      end
    end
  end

  private
    def application_root
      File.expand_path(RAILS_ROOT)
    end

    def gem_root
      @gem_root ||= File.expand_path(File.dirname(__FILE__) + "/../..")
    end

    def asset_destination_dir
      @destination_dir ||= File.expand_path("#{application_root}/public/plugin_assets/chili_pdf")
    end

    def asset_source_dir
      @source_dir ||= File.expand_path(gem_root + "/assets")
    end

    def gem_db_migrate_dir
      @gem_db_migrate_dir ||= File.expand_path(gem_root + "/db/migrate")
    end

    def remove_symlink(symlink_file)
      File.unlink(symlink_file)
    rescue Errno::ENOENT # file did not exist...ignore this error
    end

    def add_symlink(source, destination)
      remove_symlink destination
      system("ln -s #{source} #{destination}")
    end

    def post_uninstall_steps
      [
        "!!!!! MANUAL STEPS !!!!!",
        "\t1. In your 'config/environment.rb', remove:",
        "\t\tconfig.gem 'chili_pdf'",
        "",
        "\t2. In your 'Rakefile', remove:",
        "\t\trequire 'chili_pdf'",
        "\t\trequire 'tasks/chili_pdf_tasks'",
        "",
        "\t3. Cycle your application server (mongrel, unicorn, etc)",
        "\n",
      ].join("\n")
    end
end

ChiliPDFTasks.new
