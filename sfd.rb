# encoding: utf-8

require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-sqlite-adapter'
require 'dm-migrations'
require 'dm-validations'
require 'haml'
require 'sass'
require 'rack-flash'
require 'pony'

configure do
	use Rack::Flash
	set :sessions, true
end

configure :development do
	@db = "sqlite::memory:"
end

configure :production do
	@db = "postgres://usr:pwd@localhost"

	not_found do
		haml "We're so sorry, but we don't know what is this."
	end

	error do
		haml "Something really nasty happened.  We're on it!"
	end
end

DataMapper.setup(:default, @db)

class Participant
	include DataMapper::Resource
	property :email, String, :key => true, :unique => true, :format => :email_address
	property :name, String, :required => true
	property :present, Boolean, :default => false
end

class Presentation
	include DataMapper::Resource
	property :id, Serial
	property :author, String, :required => true
	property :email, String, :required => true, :format => :email_address
	property :title, String, :required => true
	property :description, Text, :required => true
	property :confirmed, Boolean, :default => false
end

DataMapper.finalize
DataMapper.auto_upgrade!

helpers do
	def u(param)
		param.force_encoding(Encoding::UTF_8)	unless param == nil
	end

	def send_mail(email, type)
		Pony.mail(:to => email, :from => 'sfdcg2010@email.com', :subject => "[SFD2010-CG] #{type} feita com sucesso!", :via => :smtp, :via_options => {
			:address        => "smtp.sendgrid.net",
			:port           => "25",
			:authentication => :plain,
			:user_name      => ENV['SENDGRID_USERNAME'],
			:password       => ENV['SENDGRID_PASSWORD'],
			:domain         => ENV['SENDGRID_DOMAIN'],
		})
	end
end

get '/stylesheet/application.css' do
	content_type 'text/css', :charset => 'utf-8'
	sass :stylesheet, :style => :compact
end

get '/' do
  @participants = Participant.all.length
	@presentations = Presentation.all.length
	haml :index, :layout => false
end

get '/registration' do
	haml :registration
end

post '/registration' do
	participant = Participant.create(:email => u(params[:email]), :name => u(params[:name]))
	if participant.save
		flash[:notice] = "Você está inscrito para participar do SFD 2010 - Campina Grande!"
		send_mail(participant.email, "Inscrição")
		redirect '/'
	else
		@errors = participant.errors
		haml :registration
	end
end

get '/presentation' do
	haml :presentation
end

post '/presentation' do
	presentation = Presentation.create(:author => u(params[:author]), :email => u(params[:email]), :title => u(params[:title]), :description => u(params[:description]))
	if presentation.save
		flash[:notice] = "Proposta de palestra submetida com sucesso!"
		send_mail(presentation.email, "Submissão")
		redirect '/'
	else
		@errors = presentation.errors
		haml :presentation
	end
end

get '/certificate' do
	# TODO
	haml :certificate
end
