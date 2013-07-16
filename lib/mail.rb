require 'pony'

def send_mail(params)
  name = h params[:name]
  mail = h params[:mail]
  body = h params[:body]
  Pony.mail(
    name: params[:name],
    mail: params[:mail],
    to: ENV['EMAIL_TO'],
    subject: params[:name] + " entrou em contato pelo site",
    body: "Nome: #{params[:name]} \nEmail: #{params[:mail]} \n\nMensagem: #{params[:body]}",
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
end

def validate params
  errors = {}
  [:name, :mail, :body].each{|key| params[key] = (params[key] || "").strip }
  errors[:name] = "Este campo é obrigatório" unless given? params[:name]
  errors[:name] = "Este campo está muito curto" unless valid_size?(params[:name], 3)
  if given? params[:mail]
    errors[:mail] = "Este email não é válido" unless valid_email? params[:mail]
  else
    errors[:mail] = "Este campo é obrigatório"
  end
  errors[:body] = "Este campo é obrigatório" unless given? params[:body]
  errors[:body] = "Este campo está muito curto" unless valid_size?(params[:body], 5)
  errors
end

def valid_email? email
  if email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
    domain = email.match(/\@(.+)/)[1]
    Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    @mx.size > 0 ? true : false
  else
    false
  end
end

def valid_size? field, n
  field.to_s.size >= n
end

def given? field
  !field.empty?
end

def h(text)
  Rack::Utils.escape_html(text)
end