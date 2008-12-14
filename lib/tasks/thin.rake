###############################
# Writen by Frederico Araujo  #
# Distributed under: GNU LGPL #
###############################

# Custom thin tasks for Running Thin servers
# Only works on UNIX Systems: 
#   Linux, Bsd or OSX

require 'yaml'

@config_file = "#{RAILS_ROOT}/config/thin.yml"

@default_dev_port = 3000
@default_dev_pid = "tmp/pids/thin_dev.pid"
@default_dev_log = "tmp/pids/thin_dev.log"
@default_prod_port = 3001
@default_prod_pid ="tmp/pids/thin_prod.pid"
@default_prod_log = "tmp/pids/thin_prod.log"


# load vars from defaults
def load_defaults
  @dev_port = @default_dev_port
  @dev_pid = @default_dev_pid
  @dev_log = @default_dev_log
  @prod_port = @default_prod_port
  @prod_pid = @default_prod_pid
  @prod_log = @default_prod_log
end

# Load variables from thin.yml file if it exists
def load_vars
  config = YAML.load_file(@config_file)
  @dev_port = config["development"]["port"] ||= @default_dev_port
  @dev_pid = config["development"]["pid"] ||= @default_dev_pid
  @dev_log = config["development"]["log"] ||= @default_dev_log
  @prod_port = config["production"]["port"] ||= @default_prod_port
  @prod_pid = config["production"]["pid"] ||= @default_prod_pid
  @prod_log = config["production"]["log"] ||= @default_prod_log
end

# build the command line options
def options_build
  @prod_options = "--port #{@prod_port} --log #{@prod_log} --pid #{@prod_pid} -e production -d"
  @dev_options  = "--port #{@dev_port} --log #{@dev_log}  --pid #{@dev_pid}  -e development -d"
end


# setup everything
def setup
  if File.exist?(@config_file)
    load_vars
  else
    # load defaults if config file is not there
    load_defaults
    puts "="*30
    puts "Warning: "
    puts "   The file /config/thin.yml does not exist,"
    puts "   Using defaults."
    puts "="*30
  end
  options_build
end

desc "Custom thin tasks for Running Thin"
namespace "thin" do
  
  # setup variables
  setup
  
  # stop tasks
  namespace :stop do
    desc "Stop development thin servers" 
    task :development => :environment do
      puts "... Stoping development thin server"
      `cd #{RAILS_ROOT}`
      `thin stop #{@dev_options}`
    end
    desc "Stop production thin servers" 
    task :production => :environment do
      puts "... Stoping production thin server"
      `cd #{RAILS_ROOT}`
      `thin stop #{@prod_options}`
    end
    desc "Stop all thin servers" 
    task :all => :environment do
      puts "... Stoping all thin servers"
      `cd #{RAILS_ROOT}`
      `thin stop #{@prod_options}`
      `thin stop #{@dev_options}`
    end    
  end
  
  # start tasks
  namespace :start do
    desc "Start Development thin server"
    task :development => :environment do
      puts "... Starting Development thin server"
      `cd #{RAILS_ROOT}`
      `thin start #{@dev_options}`
    end
    desc "Start Production thin server"
    task :production => :environment do
      puts "... Starting Production thin server"
      `cd #{RAILS_ROOT}`
      `thin start #{@prod_options}`
    end
    desc "Start both thin servers"
    task :all => :environment do
      puts "... Starting all Thin servers"
      `cd #{RAILS_ROOT}`
      `thin start #{@prod_options}`
      `thin start #{@dev_options}`
    end    
  end
  
  # reload
  desc "Quick Reload Thin servers"
  task :reload => :environment do
    puts "... Reloading all Thin Servers"
    `cd #{RAILS_ROOT}`
    `kill -HUP \`cat #{@prod_pid}\``
    `kill -HUP \`cat #{@dev_pid}\``
  end

  desc "Quick Reload Production Thin server"
  task "reload:production" => :environment do
    puts "... Reloading Thin Production Server"
    `cd #{RAILS_ROOT}`
    `kill -HUP \`cat #{@prod_pid}\``
  end
  
  desc "Quick Reload Development Thin server"
  task "reload:development" => :environment do
    puts "... Reloading Thin Development Server"
    `cd #{RAILS_ROOT}`
    `kill -HUP \`cat #{@dev_pid}\``
  end
  
  # restart tasks
  desc "Full Restart thin servers"
  task :restart => :environment do
    puts "... Stopping all Thin Servers"
    `cd #{RAILS_ROOT}`
    `thin stop #{@prod_options}`
    `thin stop #{@dev_options}`
    sleep 2
    `thin start #{@prod_options}`
    `thin start #{@dev_options}`
  end
  
  desc "Thin Servers Status"
  task :show_config => :environment do
    puts "... Thin Servers:"
    puts "Production Command : \"thin start/stop #{@prod_options}\""
    puts "Development Command: \"thin start/stop #{@dev_options}\""
  end
  
end