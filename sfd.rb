require 'rubygems'
require 'sinatra'
require 'environment'
require 'models'
require 'haml'
require 'sass'

get '/stylesheet/application.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet, :style => :compact
end

get '/' do
  @proposals = Proposal.all.length
  haml :index, :layout => false
end

get '/agenda' do
	haml :schedule
end

get '/proposta/:id' do |id|
  @proposal = Proposal.get(id)
  haml :proposal
end

get '/submissao' do
  haml :registration_proposal
end

post '/submissao' do
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

post '/admin/proposta/:id' do
  puts '------------------'
  puts params[:checked]
  puts params[:id]
  puts '------------------'
  redirect '/admin/propostas'
end

