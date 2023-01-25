class BootstrapDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  # If there is an object in your application that returns a contact email, you can use it as follows
  # Note that Devise passes a Devise::Mailer object to your proc, hence the parameter throwaway (*).
  # default from: ->(*) { Class.instance.email_address }

  layout 'bootstrap-mailer'

  def devise_mail(record, action, opts = {}, &block)
    initialize_from_record(record)
    puts "BS MAiler"
    bootstrap_mail headers_for(action, opts), &block
  end
end
