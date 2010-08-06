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
  haml :index, :layout => false
end

get '/proposal/:id' do |id|
  @proposal = Proposal.get(id)
  haml :proposal
end

get '/registration/participant' do
  haml :registration_participant
end

post '/registration/participant' do
  participant = Participant.create(:email => params[:email], :name => params[:name])
  if participant.save
    flash[:notice] = "Você está inscrito para participar do SFD 2010 - Campina Grande!"
    #send_mail(participant.email, "Inscrição")
    redirect '/'
  else
    @errors = participant.errors
    haml :registration_participant
  end
end

get '/registration/proposal' do
  haml :registration_proposal
end

post '/registration/proposal' do
  proposal = Proposal.create(:author => params[:author], :email => params[:email], :title => params[:title], :description => params[:description])
  if proposal.save
    flash[:notice] = "Proposta de palestra submetida com sucesso!"
    #send_mail(presentation.email, "Submissão")
    redirect '/'
  else
    @errors = proposal.errors
    haml :registration_proposal
  end
end

get '/admin/proposals' do
  @proposals = Proposal.all(:order => [ :confirmed.desc, :title.asc ])
  @confirmed = Proposal.all(:confirmed => true).length
  haml :admin_proposals
end

get '/admin/participants' do
  @participants = Participant.all(:order => [ :present.desc, :name.asc ])
  @presents = Participant.all(:present => true).length
  haml :admin_participants
end

get '/certificate' do
  haml :certificate
end
