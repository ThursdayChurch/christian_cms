# Be sure to restart your web server when you modify this file.
require 'rubygems'

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

ENV['FERRET_USE_LOCAL_INDEX'] ||= "1"

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :active_resource, :action_mailer ]
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  #config.frameworks -= [ :action_web_service ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  config.action_controller.session = {
    :session_key => '_archivo_session',
    :secret      => '91cf382a47f45daadc6d8e0295875ca3'
  }

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :p_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options
  
  #config.action_mailer.delivery_method = :smtp
  config.action_mailer.delivery_method = :sendmail
  
  config.action_mailer.smtp_settings = {
    :address        => "www.comunidad-catolica.com",
    :port           => 25,
    :domain         => "www.comunidad-catolica.com"
  }

  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory is automatically loaded
  
  module SettingsDefaults
    DEFAULTS = {
      :subtitle => 'Comunidad Catolica',
      :per_page => 20
    }
  end

  config.load_paths += Dir["#{RAILS_ROOT}/vendor/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

end

ActionMailer::Base.sendmail_settings = {
  :location       => '/usr/sbin/sendmail',
  :arguments      => '-i -t -f admin@comunidad-catolica.com'
}

# Include your application configuration below
PASSWORD_SALT = 'XPeop348I25cag0ab580x26e2168698' unless Object.const_defined?(:PASSWORD_SALT)

#ActionMailer::Base.sendmail_settings = {
#  :location       => '/usr/sbin/sendmail',
#  :arguments      => '-i -t -f fred@comunidad-catolica.com'
#}

#include Spawn
#ActiveRecord::Base.allow_concurrency = true
#Spawn::method :fork

require 'will_paginate'
require 'fastercsv'
require "google_query"
require 'yahoo-weather'
