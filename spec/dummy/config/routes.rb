Dummy::Application.routes.draw do
  get 'stache', :to => 'stache#index', :as => 'stache'

  get 'stache/with_layout', :to => 'stache#with_layout'

  get 'stache/helper', :to => 'stache#helper'

  get 'stache/with_partials', :to => 'stache#with_partials'

  get 'stache/with_asset_helpers', :to => 'stache#with_asset_helpers'

  get 'stache/with_wrapper', :to => 'stache#with_wrapper'

  get 'stache/no_format_in_extension', :to => 'stache#no_format_in_extension'

  get 'stache/no_format_in_extension_with_wrapper', :to => 'stache#no_format_in_extension_with_wrapper'

  get 'handlebars', :to => 'handlebars#index', :as => 'handlebars'

  get 'handlebars/with_partials', :to => 'handlebars#with_partials'

  get 'handlebars/with_helpers', :to => 'handlebars#with_helpers'

  get 'handlebars/with_missing_data', :to => 'handlebars#with_missing_data'

  get 'handlebars/with_wrapper', :to => 'handlebars#with_wrapper'
end
