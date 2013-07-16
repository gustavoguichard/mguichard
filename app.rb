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
  sass :'sass/style', style: :compressed
end

post '/contact' do 
  require 'pony'
  Pony.mail(
    name: params[:name],
    mail: params[:mail],
    body: params[:body],
    to: 'gustavoguichard@gmail.com',
    subject: params[:name] + " entrou em contato pelo site",
    body: params[:message],
    port: '587',
    via: :smtp,
    via_options: {
      address: 'smtp.gmail.com',
      port: '587',
      enable_starttls_auto: true,
      user_name: ENV['EMAIL_USERNAME'],
      password: ENV['EMAIL_PASSWORD'],
      authentication: :plain,
      domain: 'mguichard.com.br'
    })
  redirect '/'
end

not_found do
  redirect to('/')
end

error do
  'Oops. I think someone triped the power cord.'
end