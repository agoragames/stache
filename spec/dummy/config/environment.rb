# Load the rails application
require File.expand_path('../application', __FILE__)

Dummy::Application.config.autoload_paths << Rails.root + 'app/views'

# Initialize the rails application
Dummy::Application.initialize!
