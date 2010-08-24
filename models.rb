require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

DataMapper.setup(:default, @db)

class Proposal
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

