require 'pony'

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
