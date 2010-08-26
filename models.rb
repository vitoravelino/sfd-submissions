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
  property :title, String, :required => true, :message => "Sua proposta precisa de um título"
  property :category, String, :required => true, :message => "Sua proposta precisa de uma categoria"
  property :description, Text, :required => true, :message => "Sua proposta precisa de uma descrição"

  validates_within :category, :set => ["Iniciante", "Avançado", "Tutorial"], :message => "A categoria precisa ser 'Iniciante', 'Avançado' ou 'Tutorial'"
end

DataMapper.finalize
DataMapper.auto_upgrade!

