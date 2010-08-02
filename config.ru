require 'sfd'
require 'rack-flash'

use Rack::Flash

run Sinatra::Application
