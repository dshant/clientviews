class ResponseNotificationMailer < ApplicationMailer

  def notification_email
    @response = params[:response]
    email = params[:email]
    to = email || @response.survey.account.users.first.email
    @preview = "Check out the response!"
    bootstrap_mail(
      to: to,
      subject: "A new response to your #{@response.survey.name} survey",
    )
  end

end
