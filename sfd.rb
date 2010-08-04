require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'rack-flash'
require 'haml'
require 'sass'

configure do
	set :sessions, true
	use Rack::Flash
end

configure :development do
	require 'dm-sqlite-adapter'
	@db = "sqlite::memory:"
end

configure :production do
	require 'pony'
	@db = ENV['DATABASE_URL']

	not_found do
		haml "We're so sorry, but we don't know what is this."
	end

	#error do
#		haml "Something really nasty happened.  We're on it!"
#	end
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
	participant = Participant.create(:email => params[:email], :name => params[:name])
	if participant.save
		flash[:notice] = "Você está inscrito para participar do SFD 2010 - Campina Grande!"
		#send_mail(participant.email, "Inscrição")
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
	presentation = Presentation.create(:author => params[:author], :email => params[:email], :title => params[:title], :description => params[:description])
	if presentation.save
		flash[:notice] = "Proposta de palestra submetida com sucesso!"
		#send_mail(presentation.email, "Submissão")
		redirect '/'
	else
		@errors = presentation.errors
		haml :presentation
	end
end

get '/admin/presentation' do
	@confirmed_presentations = Presentation.all(:confirmed => true)
	@other_presentations = Presentation.all(:confirmed => false)
	haml :admin_presentation
end

get '/admin/participant' do
	@confirmed_participants = Participant.all(:present => true)
	@other_participants = Participant.all(:present => false)
	haml :admin_participant
end

get '/certificate' do
	haml :certificate
end
