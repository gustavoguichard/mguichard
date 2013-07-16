%w(sinatra compass slim sass ./lib/mail).each{|g| require g}
require './configs' unless Sinatra::Base.production?

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
    config.images_dir = 'public/images'
    config.http_images_path = "/images"
  end

  set :slim, { format: :html5 }
  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
end

get '/' do
  @partners = set_partners
  slim :index
end

get '/hello/:name' do
  "Hello ther, #{params[:name]}!!"
end

post '/contact' do 
  @errors = validate(params)

  if @errors.empty?
    begin
      send_mail(params)
      @sent = true
    rescue Exception => e
      puts e
      puts "Ooops, it looks like something went wrong while attempting to send your email. Mind trying again now or later? :)"
    end
  else
    @partners = set_partners
    return slim :index
  end
  redirect '/'
end

not_found do
  redirect to('/')
end

get '/style.css' do
  sass :'sass/style', style: :compressed
end

error do
  'Oops. I think someone triped the power cord.'
end

def set_partners
  partners = [
      {name: "Fibraplac", img: "images/fabricas/fibraplac.jpg", url: "http://www.fibraplac.com.br/"},
      {name: "Isdralit", img: "images/fabricas/isdralit.jpg", url: "http://www.isdralit.com.br/"},
      {name: "Dacar", img: "images/fabricas/dacar.jpg", url: "http://www.dacar.ind.br/"},
      {name: "Pisoforte", img: "images/fabricas/pisoforte.jpg", url: "http://www.pisoforte.com.br/"},
      {name: "Van Gogh", img: "images/fabricas/vangogh.jpg", url: "http://www.vangoghrevestimentos.com.br/"},
      {name: "Fortkoll", img: "images/fabricas/fortkoll.jpg", url: "https://www.facebook.com/pages/Fortkoll-Argamassas-e-Rejuntes/322253637877947"}
    ]
end