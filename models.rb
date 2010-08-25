require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

DataMapper.setup(:default, @db)

class Proposal
  include DataMapper::Resource
  property :id, Serial
  property :author, String, :required => true, :message => "Precisamos do seu nome"
  property :email, String, :required => true, :format => :email_address,
  				 :messages => {
  				 		:presence => "Precisamos do seu email",
  				 		:format => "Este valor de email não se parece com um email"
  				 }
  property :title, String, :required => true, :message => "Precisamos do título da sua proposta"
  property :description, Text, :required => true, :message => "Precisamos de uma descrição da sua proposta"
  property :category, Text, :required => true, :message => "Precisamos de uma descrição da sua proposta"
  property :confirmed, Boolean, :default => false
end

DataMapper.finalize
DataMapper.auto_upgrade!

