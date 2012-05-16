Stache.configure do |config|
  config.template_base_path = Rails.root.join('app', 'views')
  config.use :mustache
end