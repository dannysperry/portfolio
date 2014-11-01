require 'rubygems'
require 'compass'
require 'sinatra/base'
require 'sinatra/config_file'
require 'slim'

class Portfolio < Sinatra::Base
  # set sinatra's variables
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :views, "views"
  set :public_folder, 'assets'

  register Sinatra::ConfigFile
  config_file './config/config.yml'

  configure :development do
    require 'pry'
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload 'config/*.rb'
  end

  configure do
    Compass.add_project_configuration(File.join(root, 'config', 'compass.rb'))
  end

  get '/stylesheets/:name' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  error do
      slim :'errors/500'
    end

  not_found do
    slim :'errors/404'
  end

  get '/' do
    slim :index
  end

  post '/' do
    options = {
      to: 'danny.sperry@gmail.com',
      from: params[:email],
      subject: "#{params[:name]} contacted you from dannysperry.com",
      body: params[:message],
      :via => :smtp,
      :via_options => {
        :address        => 'smtp.gmail.com',
        :port           => '465',
        :enable_starttls_auto => true,
        :user_name      => settings.gmail_user_name,
        :password       => settings.gmail_password,
        :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain         => "www.dannysperry.com" # the HELO domain provided by the client to the server
      }
    }

    Pony.mail(options)

    slim :index
  end

  run! if app_file == $0
end