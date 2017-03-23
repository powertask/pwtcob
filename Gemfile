source 'https://rubygems.org'
ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.0.2'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'
gem 'jquery-turbolinks'

gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'
gem 'simple_form'
gem 'unicorn'
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'sprockets-rails', :require => 'sprockets/railtie'
gem 'cancancan', '~> 1.10'
gem 'responders'
gem 'brazilian-rails'
gem 'will_paginate'
gem 'rails_12factor'
gem 'boletosimples'
gem 'prawn'
gem 'prawn-table'
gem 'rubyzip'
gem 'roo'

gem 'bootstrap_form'


source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'awesome_print', :require => false
  gem 'thin'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

