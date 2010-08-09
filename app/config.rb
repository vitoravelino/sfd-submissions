require 'rack-flash'

configure do
  set :sessions, true
  use Rack::Flash
end

configure :development do
  require 'dm-sqlite-adapter'
  @db = "sqlite::memory:"
	require 'pdfkit'
	PDFKit.configure do |config|
	config.wkhtmltopdf = '/home/vitoravelino/wkhtmltopdf'
		config.default_options = {
			:page_size => 'Legal',
			:print_media_type => true
	}
	end
end

configure :production do
  require 'dm-postgres-adapter'
	@db = ENV['DATABASE_URL']

  not_found do
    haml "We're so sorry, but we don't know what is this."
  end

  error do
    haml "Something really nasty happened.  We're on it!"
 end
end
