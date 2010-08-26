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
  haml :index
end

get '/proposta/:id' do |id|
  @proposal = Proposal.get(id)
  haml :proposal
end

get '/submissao' do
  haml :registration_proposal
end

post '/submissao' do
  proposal = Proposal.create(:author => params[:author], :email => params[:email], :title => params[:title], :category => params[:category], :description => params[:description])
  if proposal.save
    flash[:notice] = "Proposta submetida com sucesso!"
    redirect '/'
  else
    @errors = proposal.errors
    haml :registration_proposal
  end
end

get '/admin' do
  @proposals = Proposal.all(:order => [ :category.desc, :title.asc ])
  haml :admin_proposals
end

get '/test' do
	proposals = Proposal.all(:order => [ :category.desc, :title.asc ])
	headers "Content-Disposition" => "attachment;filename=proposals.csv",
  				"Content-Type" => "application/octet-stream"
  result = ""
  proposals.each do |proposal|
    result << "\"#{proposal.category}\";\"#{proposal.title}\";\"#{proposal.description}\"\n"
  end
	puts result
  result
end

