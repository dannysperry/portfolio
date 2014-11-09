require 'rubygems'
require 'compass'
require 'sinatra/base'
require 'sinatra/config_file'
require 'slim'
require 'mail'

# Base routes and setup actions for racks config.ru
class Portfolio < Sinatra::Base
  # set sinatra's variables
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :views, 'views'
  set :public_folder, 'assets'

  register Sinatra::ConfigFile
  config_file './config/config.yml'

  configure :development do
    require 'pry'
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload 'config/*.rb'
  end

  configure do
    Compass.add_project_configuration(File.join(root, 'config', 'compass.rb'))
    Mail.defaults do
      delivery_method :smtp,
                      address: 'smtp.gmail.com',
                      port: '425',
                      domain: 'heroku.com',
                      user_name: ENV['GMAIL_USERNAME'],
                      password: ENV['GMAIL_PASSWORD'],
                      authentication: 'plain',
                      enable_starttls_auto: true
    end
  end

  get '/stylesheets/:name' do
    content_type 'text/css', charset: 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  error do
    slim :error
  end

  not_found do
    slim :not_found
  end

  get '/' do
    slim :index
  end

  post '/' do
    mail = Mail.new do
      to 'danny.sperry@gmail.com'
      from 'danny@wearefine.com'
      subject 'Feedback for my Sintra app'
      text_part do
        body 'test message'
      end
    end

    mail.delivery_method :smtp
    mail.deliver

    slim :index
  end

  get '/resume' do
    send_file File.join(File.dirname(__FILE__), 'assets', 'Resume-DannySperry.pdf')
  end

  run! if app_file == $PROGRAM_NAME
end
