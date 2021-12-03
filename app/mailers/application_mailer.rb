class ApplicationMailer < ActionMailer::Base
  default from: ENV['MATCHASIA_SMTP_MAILFROM']
  layout 'mailer'
end
