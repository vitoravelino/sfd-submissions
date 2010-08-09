ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR
puts ROOT_DIR
require 'rubygems'
require 'sinatra'
require 'app/config'
require 'app/models'
#require 'app/helpers'
require 'haml'
require 'sass'

get '/stylesheet/application.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet, :style => :compact
end

get '/' do
  @participants = Participant.all.length
  @proposals = Proposal.all.length
  haml :index
end

get '/proposta/:id' do |id|
  @proposal = Proposal.get(id)
  haml :proposal
end

get '/inscricao' do
  haml :registration_participant
end

post '/inscricao' do
  participant = Participant.create(:email => params[:email], :name => params[:name])
  if participant.save
    flash[:notice] = "Você está inscrito para participar do SFD 2010 - Campina Grande!"
    redirect '/'
  else
    @errors = participant.errors
    haml :registration_participant
  end
end

get '/submissao' do
  haml :registration_proposal
end

post '/subsmissao' do
  proposal = Proposal.create(:author => params[:author], :email => params[:email], :title => params[:title], :description => params[:description])
  if proposal.save
    flash[:notice] = "Proposta de palestra submetida com sucesso!"
    redirect '/'
  else
    @errors = proposal.errors
    haml :registration_proposal
  end
end

get '/admin/propostas' do
  @proposals = Proposal.all(:order => [ :confirmed.desc, :title.asc ])
  @confirmed = Proposal.all(:confirmed => true).length
  haml :admin_proposals
end

get '/admin/inscricoes' do
  @participants = Participant.all(:order => [ :present.desc, :name.asc ])
  @presents = Participant.all(:present => true).length
  haml :admin_participants
end

get '/certificado' do
	haml :certificate
end

get '/certificado/:email' do
	@name = Participant.get(:email => params[:email])
	haml :certificate_pdf, :layout => false
end

post '/certificado-sfd2010.pdf' do
	content_type 'application/pdf'
	kit = PDFKit.new('http://localhost:4567/certificate/:name')
	kit.to_pdf
end

get '/agenda' do
	haml :schedule
end
