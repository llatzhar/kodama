require 'bundler/setup'
Bundler.require(:default)
Bundler.require(:development) if development?

require './main.rb'

## There is no need to set directories here anymore;
## Just run the application

run Sinatra::Application
