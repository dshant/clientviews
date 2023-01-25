class AppReplyMailer < ApplicationMailer
  def notification_email
    @reply = params[:reply]
    to = @reply.response.email
    @preview = "There is an update to your response!"
    bootstrap_mail(
      to: to,
      subject: "You have a new reply to your survey response!",
    )
  end
end
