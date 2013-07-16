require 'sinatra'
require 'slim'
require 'sass'
require 'pony'

get '/' do
  slim :index
end

get '/hello/:name' do
  "Hello ther, #{params[:name]}!!"
end

get '/style.css' do
  sass :'sass/style', :style => :compressed
end

post '/form' do  
  "You said '#{params[:message]}'"  
end

not_found do
  redirect to('/')
end

error do
  'Oops. I think someone triped the power cord.'
end