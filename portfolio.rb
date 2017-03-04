require 'rubygems'
require 'compass'
require 'sinatra/base'
require 'sinatra/config_file'
require 'slim'
require 'json'
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

  Mail.defaults do
    delivery_method :smtp,
                    address: 'smtp.gmail.com',
                    port: '25',
                    domain: 'heroku.com',
                    user_name: ENV['GMAIL_USERNAME'],
                    password: ENV['GMAIL_PASSWORD'],
                    authentication: 'plain',
                    enable_starttls_auto: true
  end

  configure :development do
    require 'pry'
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload 'config/*.rb'
  end

  configure do
    Compass.add_project_configuration(File.join(root, 'config', 'compass.rb'))
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

  post '/mail/growers_outlet' do
    content_type :json
    headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['POST']
    mail = Mail.new { to 'dannysperry@gmail.com' }
    mail[:from] = "#{params[:email]}"
    mail[:body] = "Hey Growers Outlet!

    #{params[:message]}

    #{params[:name]}"
    mail[:subject] = "#{params[:name]} has sent you a message from your website"
    mail.deliver!
  end

  post '/' do
    mail = Mail.new { to 'danny.sperry@gmail.com' }
    mail[:from] = "#{params[:email]}"
    mail[:body] = "From #{params[:email]},

    #{params[:message]}"
    mail[:subject] = "dannysperry.com - #{params[:name]}"
    mail.deliver!

    redirect '/'
  end

  get '/resume' do
    send_file File.join(File.dirname(__FILE__), 'assets', 'Resume-DannySperry.pdf')
  end

  run! if app_file == $PROGRAM_NAME
end
